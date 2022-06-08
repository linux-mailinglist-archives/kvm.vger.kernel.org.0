Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E70D543193
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbiFHNjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240325AbiFHNje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:39:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9657318F864;
        Wed,  8 Jun 2022 06:39:33 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258CMlM3015920;
        Wed, 8 Jun 2022 13:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gjVNVy0ab7qiHXgN+goUGpa8koTo72OvccFIyW70+C8=;
 b=NvIEAY5LWw1e6gahqyaaKvkop+0K+IrZ5eq39R+jLf4qaqFVfDFfzwOS1NVgBRFv8XHO
 fKh2F0bXdKZ10ojNjalaNDg/qPtDvgw56SHNYXfWFdPUfv0LthXz5CLNLoh+BRHF8TXk
 jeCamDq8WBySqdI3etPd06uAVWivlpYg1FEfoP/4pLWF8flWJBkQZFcViS+ZbvPRHfBh
 XcrJ5UfK/gql74nWCOyQBbRslMSN4sP2avWwZSwCTz1mHp0gwHzMqf6P56N8oFt/RVdY
 pHENqRF3fXCLqFr0mmnD4UBYrj40XeKHCalg9d7vBOpXUjmalw0KsU0Nn5dfNHF8Z3w7 EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjuqn9nh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:39:32 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DD9Yu001313;
        Wed, 8 Jun 2022 13:39:32 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjuqn9nfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:39:32 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258DLKrm020411;
        Wed, 8 Jun 2022 13:39:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3gfy18v6d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:39:30 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DdRAq14746026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:39:27 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15DD711C04C;
        Wed,  8 Jun 2022 13:39:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF87011C04A;
        Wed,  8 Jun 2022 13:39:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 13:39:26 +0000 (GMT)
Date:   Wed, 8 Jun 2022 15:39:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v4 0/1] s390x: add migration test for
 storage keys
Message-ID: <20220608153925.4f93cb68@p-imbrenda>
In-Reply-To: <20220608131328.6519-1-nrb@linux.ibm.com>
References: <20220608131328.6519-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mT--rQsuA2xhYvKa1tS79KV0sFNfiTpH
X-Proofpoint-GUID: NFZ0eP0vpiWlTKblUyjWAAWZARsdaq08
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080058
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  8 Jun 2022 15:13:27 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

thanks, queued

> v3->v4:
> ----
> * remove useless goto (Thanks Thomas)
> 
> v2->v3:
> ----
> * remove some useless variables, style suggestions, improve commit description
>   (thanks Janis)
> * reverse christmas tree (thanks Claudio)
> 
> v1->v2:
> ----
> * As per discussion with Janis and Claudio, remove the actual access check from
>   the test. This also allows us to remove the check_pgm_int_code_xfail() patch.
> * Typos/Style suggestions (thanks Janis)
> 
> Upon migration, we expect storage keys set by the guest to be preserved,
> so add a test for it.
> 
> We keep 128 pages and set predictable storage keys. Then, we migrate and check
> they can be read back.
> 
> Nico Boehr (1):
>   s390x: add migration test for storage keys
> 
>  s390x/Makefile         |  1 +
>  s390x/migration-skey.c | 73 ++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg    |  4 +++
>  3 files changed, 78 insertions(+)
>  create mode 100644 s390x/migration-skey.c
> 

