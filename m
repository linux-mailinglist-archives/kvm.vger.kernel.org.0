Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EC74C0EFD
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 10:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbiBWJTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 04:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiBWJTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 04:19:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3366538BCE;
        Wed, 23 Feb 2022 01:18:38 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N7Ydiv026117;
        Wed, 23 Feb 2022 09:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=yzhTMQTcEhWjx4bSnLRjix08iDpRDmXieVMBVfpfDt0=;
 b=gTQgVa0Ivur1i1Td5TqkZNINn7wll8dVeoKRx7AaKI9dqm9ItY5hT/P5DUuuFB4Ida4a
 OqN6iGX4sdw6cOCbOtU7JIxq0Qe+UeKgOhVg5I+2xHb8SEzC3pDiGkrCYcQedB3lDCzz
 TrmX1BedNT8lhcvJ4vfRGiOEbcdxALwgEEaJdurL9tFNUK2WXBHP42zygL9t4/LLUuf+
 yVIhWjVmYO3qIsxeGCkb+paVVn/H48UE9tQQ6elbri8stimSRF73z9l49dTCGrpbojuw
 EvnI5y9q3zsKmEEXg8a7p0dfn6/ajLH87/uNFcbJ5ZmXTvW8nUfhdf9k+xAXZ4CzCH0r 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edct6wxdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:18:37 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21N9FmB8013670;
        Wed, 23 Feb 2022 09:18:37 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edct6wxd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:18:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21N9CP4f022143;
        Wed, 23 Feb 2022 09:18:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3ear6973ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 09:18:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21N9ISuI54788500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 09:18:28 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A615711C050;
        Wed, 23 Feb 2022 09:18:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55CFD11C04C;
        Wed, 23 Feb 2022 09:18:28 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.67.143])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 09:18:28 +0000 (GMT)
Message-ID: <c13d9fbb6591eba99fc4aa8b884a8f516140b2d2.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/8] s390x: Extend instruction
 interception tests
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com, david@redhat.com
Date:   Wed, 23 Feb 2022 10:18:28 +0100
In-Reply-To: <0bb8a574-059c-f356-fcd1-74d0bc41fa1a@linux.ibm.com>
References: <20220221130746.1754410-1-nrb@linux.ibm.com>
         <0bb8a574-059c-f356-fcd1-74d0bc41fa1a@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xkCuh3ICoaIk03iEmhyuCkGLnPU4wPJO
X-Proofpoint-GUID: ju-tUvaM7o0TroTXH2tveONE871qLSiR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-23_03,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202230049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-02-21 at 16:30 +0100, Janosch Frank wrote:
> Could you please push this to devel so we can get CI data?

Thanks Janosch, we found an issue in the CI. A fix is in the making.
