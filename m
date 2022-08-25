Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9E85A139A
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 16:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbiHYOaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 10:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbiHYOaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 10:30:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6A5FD14
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 07:30:20 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PEPJlN008247
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kFg/rjgbftqsfRVzDdPJPUmLL2mlmemHqsg7WGPfXH0=;
 b=PlIpfCR2tOayKPPBBg/QGxkCQxdPF2l+uf4JHZqVr/wvQiakfillgkwtpukQ9HYEv1F8
 11NwrP6sanQ2zuwJ2yNAieAJFapgWmgndEAx6b6nLbNFSF1IftGl/Q7nCKPBkWbN2WNx
 jhKrJ3lltixuhVjHQScdGL7/EtYRcSJ1Rt5Wr/3y7j1IXXazYEaVjp3ocp8ntmhXDmw2
 fkn7XUNKWV32bbskfpY7hCS0mbk8d+y7WDlpAwfXI/YSvaQeeKMN/fApoy4tlQHdA1qf
 wB2SuFKlkJkKaMTSncyq2kvKep2Nn6S5/FdRuOiS5tiUBjFY9v4iPs7xrhYMFgtFPGnY PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6au38572-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:30:19 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27PEPf7M009457
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 14:30:19 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6au38565-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 14:30:19 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27PEKmqS012693;
        Thu, 25 Aug 2022 14:30:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3j2q88vsqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 14:30:17 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27PEUEXh33751360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 14:30:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31DEB5204E;
        Thu, 25 Aug 2022 14:30:14 +0000 (GMT)
Received: from [9.145.149.19] (unknown [9.145.149.19])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id ED3C05204F;
        Thu, 25 Aug 2022 14:30:13 +0000 (GMT)
Message-ID: <b7603e5f-9b0e-39d5-2ae7-779e8a22c3f7@linux.ibm.com>
Date:   Thu, 25 Aug 2022 16:30:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: factor out common args for
 genprotimg
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, thuth@redhat.com
References: <20220825131600.115920-1-nrb@linux.ibm.com>
 <20220825131600.115920-2-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220825131600.115920-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I_U66r7rklLs31niKLNRrAuHmK4LxZWk
X-Proofpoint-ORIG-GUID: cmuCeox7uXsHkXYGOXBAgU3G6SbwrY-T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_05,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208250053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/22 15:15, Nico Boehr wrote:
> Upcoming changes will add more arguments to genprotimg. To avoid
> duplicating this logic, move the arguments to genprotimg to a variable.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   s390x/Makefile | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..d17055ebe6a8 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -165,11 +165,13 @@ $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>   %.bin: %.elf
>   	$(OBJCOPY) -O binary  $< $@
>   
> +genprotimg_args = --host-key-document $(HOST_KEY_DOCUMENT) --no-verify
> +
>   %selftest.pv.bin: %selftest.bin $(HOST_KEY_DOCUMENT) $(patsubst %.pv.bin,%.parmfile,$@)
> -	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --no-verify --image $< -o $@
> +	$(GENPROTIMG) $(genprotimg_args) --parmfile $(patsubst %.pv.bin,%.parmfile,$@) --image $< -o $@
>   
>   %.pv.bin: %.bin $(HOST_KEY_DOCUMENT)
> -	$(GENPROTIMG) --host-key-document $(HOST_KEY_DOCUMENT) --no-verify --image $< -o $@
> +	$(GENPROTIMG) $(genprotimg_args) --image $< -o $@
>   
>   $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>   	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<

