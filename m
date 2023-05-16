Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C62670550B
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 19:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjEPRav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 13:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjEPRaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 13:30:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1D4A27C;
        Tue, 16 May 2023 10:30:44 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GHCBJ3003726;
        Tue, 16 May 2023 17:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4sTTnoeLU+kDni4VxpopKcMNHZCqc0+xw6oPhGSGjps=;
 b=lszo6Gz+g5e5/u6uIacdzRg3aTa4P+c+hfP21L2jNvapfvnlvOR+2Mv4XQjtmHESU+hk
 3Wl4KYIjhESEDw9aeN5rRH1n6KL3acjIdzmT/ovvCaRvnq4Y6JTsHlu6BDWx+YjBonmi
 T1MRZaCjQt6abuBQpiFF9nEtaIrFzRKNpk9cjYUSLg4l5eEDHa9zCeTGHhEuTv9CIDRX
 JBPAzqV3GaaHez6f0VO9LBk9u4o2V9ptvyaYoMFug8a98pxXKwIzA6m4Ir3+jXune20u
 3UGwgsS9grdEspI8jzOL/MZT5rY7CzxxAUUQsYyd9SUW2zjM7wzM6sOQyLP0z/scR1vB eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmd8k9rnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:44 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34GHDlSM009863;
        Tue, 16 May 2023 17:30:43 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmd8k9rmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:43 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34G4UV7s012372;
        Tue, 16 May 2023 17:30:41 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qj264ssk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 May 2023 17:30:41 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34GHUcVH20054574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 May 2023 17:30:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5871920043;
        Tue, 16 May 2023 17:30:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A1772004B;
        Tue, 16 May 2023 17:30:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 16 May 2023 17:30:38 +0000 (GMT)
Date:   Tue, 16 May 2023 19:22:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/6] s390x: sie: switch to home space
 mode before entering SIE
Message-ID: <20230516192225.2b4eea48@p-imbrenda>
In-Reply-To: <20230516130456.256205-3-nrb@linux.ibm.com>
References: <20230516130456.256205-1-nrb@linux.ibm.com>
        <20230516130456.256205-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CA4z1MrlAMOiZJPSLoQSS1webpw-ElCU
X-Proofpoint-GUID: 4qLU8HcY1yNxM8RzC99iE0wwAl9wkd-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_09,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 bulkscore=0 clxscore=1015 suspectscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160145
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 May 2023 15:04:52 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> This is to prepare for running guests without MSO/MSL, which is
> currently not possible.
> 
> We already have code in sie64a to setup a guest primary ASCE before
> entering SIE, so we can in theory switch to the page tables which
> translate gpa to hpa.
> 
> But the host is running in primary space mode already, so changing the
> primary ASCE before entering SIE will also affect the host's code and
> data.
> 
> To make this switch useful, the host should run in a different address
> space mode. Hence, set up and change to home address space mode before
> installing the guest ASCE.
> 
> The home space ASCE is just copied over from the primary space ASCE, so
> no functional change is intended, also for tests that want to use
> MSO/MSL. If a test intends to use a different primary space ASCE, it can
> now just set the guest.asce in the save_area.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---

[...]

> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 147cb0f2a556..0b00fb709776 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -284,5 +284,6 @@ void sie_handle_validity(struct vm *vm);
>  void sie_guest_sca_create(struct vm *vm);
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);
>  void sie_guest_destroy(struct vm *vm);
> +bool sie_had_pgm_int(struct vm *vm);

what's this?

>  
>  #endif /* _S390X_SIE_H_ */

