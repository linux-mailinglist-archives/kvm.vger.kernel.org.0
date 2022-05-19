Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16F852CB9E
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 07:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbiESFq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 01:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiESFqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 01:46:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF4338180;
        Wed, 18 May 2022 22:46:54 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24J5N3GO005096;
        Thu, 19 May 2022 05:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=GMCAVYWe9h4YtKksHRLK+YlbbORMosmKjjeheMgU51w=;
 b=ZhS8FzCIFaCagmfZpPInZoHNAZ21MSPuKKdgynJqA5mUlJBv6LBsBB3xQAmw174Cp123
 Y4prINLq63N+cpqMckKZuD5MGGPf/zZLHIHiPxRF0EKXC2LJQkrUQA3f3/I5mWdZ1san
 hI5iXxxYtw6jMEAuX2Ph/ynQ101mHubm0DOMruM7q0UQela7Wc5W1apXI9dNpgCy5wDN
 tKoVv+U8YU3NpIu16JoRT4af/CVlCkDtj2c1s4kX8RhNEX/PilUhsf60NWukwVr36QRV
 eHfEQbeIA39eTnyObcU5WykUI9CYp0MU8NCjUsk2uVRBLYV8JsUGqH2mGzkKa6BUWFUX XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5fpw0dy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 05:46:53 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24J5kq3g026241;
        Thu, 19 May 2022 05:46:52 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5fpw0dxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 05:46:52 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24J5koGJ026849;
        Thu, 19 May 2022 05:46:50 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjepa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 05:46:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24J5klrZ49742094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 05:46:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5924042042;
        Thu, 19 May 2022 05:46:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E636942041;
        Thu, 19 May 2022 05:46:46 +0000 (GMT)
Received: from osiris (unknown [9.152.212.254])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 19 May 2022 05:46:46 +0000 (GMT)
Date:   Thu, 19 May 2022 07:46:46 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, gor@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v9 0/3] s390x: KVM: CPU Topology
Message-ID: <YoXZxhindugH4WxI@osiris>
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
 <f9cb28d5-2aa5-f902-53ab-592b08672c62@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9cb28d5-2aa5-f902-53ab-592b08672c62@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Dt8u98nk_ah15RoTjgUmY12w3FgsvC4s
X-Proofpoint-GUID: WfklpYaMykZpt1Ufk36jTc7Mf3eYhtWc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_09,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=355 impostorscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205190035
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022 at 05:26:59PM +0200, Christian Borntraeger wrote:
> Pierre,
> 
> please use "KVM: s390x:" and not "s390x: KVM:" for future series.

My grep arts ;) tell me that you probably want "KVM: s390:" without
"x" for the kernel.
