Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698784FBB35
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 13:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343809AbiDKLss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 07:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240921AbiDKLsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 07:48:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143C845ACB;
        Mon, 11 Apr 2022 04:46:33 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B9gh5X014573;
        Mon, 11 Apr 2022 11:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5UeiQJm06XoOe8k7kH0RVxsZTVLf1BilGi/wW0ODP4M=;
 b=qrL2M0u7tjyoF1R71M9+HPlNuOE5pyhPJrHQiYW12mvpg8ARJpBe3A4n/8ilfro3BA6M
 5jni4vaq/DSIZTaISFz/tnpIu7t7VUSr57NBbtHOi7J3RMozngEtXIJzKnFb/xIiSUxk
 oXJkbWerxav3ykHCMSek3vAOfjYD6bTqjqS529s0BFWGmgOf1R6ZEvgmDOlJXI6SXXOq
 kxh/2IvcMh5FNsE8H9PWRE3d6GIaSzqDcHrOt1ScBawAp7C+8tsEi1lGs4WrBYgqhmPR
 LJ2Q8dial5wZAw+FF+cWHUu8twDvCYG3uEc10lcVhq/Ph4qJmcx5acEFGq5jJZHUGFM0 yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fceynx1kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 11:46:32 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BBdSCA000788;
        Mon, 11 Apr 2022 11:46:32 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fceynx1jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 11:46:32 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BBhZJZ030944;
        Mon, 11 Apr 2022 11:46:29 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3fb1s8td8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 11:46:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BBXxpP46596424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 11:33:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E80711C04A;
        Mon, 11 Apr 2022 11:46:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3918B11C050;
        Mon, 11 Apr 2022 11:46:26 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.68.171])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 11:46:26 +0000 (GMT)
Message-ID: <7952a0b7f61ff2ba647d4d149bf8b6996aa94293.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3] s390x: diag308: Only test subcode 2
 under QEMU
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        seiden@linux.ibm.com, imbrenda@linux.ibm.com
Date:   Mon, 11 Apr 2022 13:46:26 +0200
In-Reply-To: <20220407130252.15603-1-frankja@linux.ibm.com>
References: <20220407114253.5cb6f2aa@p-imbrenda>
         <20220407130252.15603-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: krcoLzLLtA6UVV6d4z6Yjpe4dx62U-7t
X-Proofpoint-GUID: O-UFTK7xCovPAP9GNbGqgCre03Z_ptB-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_04,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0 mlxlogscore=937
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-07 at 13:02 +0000, Janosch Frank wrote:
> Other hypervisors might implement it and therefore not send a
> specification exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
