Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F7966CEEA
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbjAPSgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbjAPSgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:36:17 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9E2CFE7
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 10:25:27 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHp2TS026206
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9HTjuVHUGhNMzF7pkIzmzk+udMW6JwHiqbGNoaLn9KI=;
 b=MonPuC1IxYsBq7QZ8KwIgqwnkTwspOgYLM2HPquqtR7meupvofpNped6y8ZQ5kFe9C2R
 lDSPmOYOf50//Otqby3d6TMiIqR3QZG/7Roue4u2Kl5A5Q5fdysFkANS5kH99zBcSajR
 rtKi4Fi65ce+jiD9G3pqEjLS5f0O2Fcv3IL9l9agKK2ydtbsXu/nVKPwwe6Iy8HL+mgz
 id4IPdOCjFBkOqXZNgz7x+UwE+sIrxfXTKkfYt2fMkavGSknUFHTN+Fdc6VeIWLByncE
 b8bI2gEavUnOqAzA3MFprAur6JYh0UK7J58o1BpHxIZqsx1H4hasrRvaLBgyRp2XmOqM hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5bbh0k0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:26 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GHqskS030681
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:26 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n5bbh0k0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30G3KH5k009464;
        Mon, 16 Jan 2023 18:25:24 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n3m16j0w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GIPLw952756962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:25:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E120E20043;
        Mon, 16 Jan 2023 18:25:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95C8020040;
        Mon, 16 Jan 2023 18:25:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 18:25:20 +0000 (GMT)
Date:   Mon, 16 Jan 2023 19:22:10 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 7/9] s390x: use C pre-processor for
 linker script generation
Message-ID: <20230116192210.7243c77f@p-imbrenda>
In-Reply-To: <20230116175757.71059-8-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
        <20230116175757.71059-8-mhartmay@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Jrea09IjFgix5HG0nXfgfXSRentpM7wx
X-Proofpoint-GUID: cEo-1WLODx_aSX_ZWioZXNNOoJ7OCYl1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Jan 2023 18:57:55 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Use the C pre-processor for the linker script generation. For example,
> this enables us the use of constants in the "linker scripts" `*.lds.S`.

please explain that the original .lds scripts are being renamed to
.lds.S, and that the .lds are now generated.

> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  .gitignore                                  | 1 +
>  s390x/Makefile                              | 6 ++++--
>  s390x/{flat.lds => flat.lds.S}              | 0
>  s390x/snippets/asm/{flat.lds => flat.lds.S} | 0
>  s390x/snippets/c/{flat.lds => flat.lds.S}   | 0
>  5 files changed, 5 insertions(+), 2 deletions(-)
>  rename s390x/{flat.lds => flat.lds.S} (100%)
>  rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
>  rename s390x/snippets/c/{flat.lds => flat.lds.S} (100%)
> 
> diff --git a/.gitignore b/.gitignore
> index 601822d67325..29f352c5ceb6 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -31,3 +31,4 @@ cscope.*
>  /s390x/comm.key
>  /s390x/snippets/*/*.hdr
>  /s390x/snippets/*/*.*obj
> +/s390x/**/*.lds

why ** ?

> diff --git a/s390x/Makefile b/s390x/Makefile
> index 31f6db11213d..45493160cdf8 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -76,7 +76,7 @@ CFLAGS += -fno-delete-null-pointer-checks
>  LDFLAGS += -nostdlib -Wl,--build-id=none
>  
>  # We want to keep intermediate files
> -.PRECIOUS: %.o
> +.PRECIOUS: %.o %.lds
>  
>  asm-offsets = lib/$(ARCH)/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
> @@ -159,6 +159,8 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SRCDI
>  %.hdr.obj: %.hdr
>  	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
>  
> +%.lds: %.lds.S
> +	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
>  
>  .SECONDEXPANSION:
>  %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
> @@ -211,7 +213,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>  
>  
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
>  
>  generated-files = $(asm-offsets)
>  $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
> diff --git a/s390x/flat.lds b/s390x/flat.lds.S
> similarity index 100%
> rename from s390x/flat.lds
> rename to s390x/flat.lds.S
> diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds.S
> similarity index 100%
> rename from s390x/snippets/asm/flat.lds
> rename to s390x/snippets/asm/flat.lds.S
> diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds.S
> similarity index 100%
> rename from s390x/snippets/c/flat.lds
> rename to s390x/snippets/c/flat.lds.S

