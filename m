Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E366C72CA
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjCWWMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWWMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:12:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E3E23120
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:12:11 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id k1-20020a632401000000b0050beb8972bfso21516pgk.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 15:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679609531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pxx832uhASjnPZ4HoOQDLIOwHuxTZHFDCnjlpP5ZNnA=;
        b=Wdx++QWdlnIPER5Di3sG6IBZaE5H9Qm5hYqBM4akKwzECCRRh3yseq/3WBAaKwHFsu
         W0l0pDxyWAALVkSf2vShio9H7qAGFXLSc7EL47z2Qo21IAigxlYySP0JhmDp45JY/5Kv
         64TXaIJ4zwyVWZxu83WwwJm6yRxXV7/IAorGH8DDm2hfxiV2EKTgH4Fq8DLj+CgH2QwS
         o/Y/cvsAnMIx+X7dHGFRsNaBRWI6y2q0LZ13hEZiV1bMJucbSf3HU3drd8igwj8ZfBP8
         FiETVyFsfJ9hTNEXshed9EMcZOWAJSR/e1VKvE/+mh3DLo6CiaEOp11XjA7iV+2dlsON
         GgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679609531;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pxx832uhASjnPZ4HoOQDLIOwHuxTZHFDCnjlpP5ZNnA=;
        b=BSWEaUPizPvxkncSVEYMIwuDJ2XxRGo1Rxi0RqR4+7RAEarVc0L6M0uIk0o8t5u1dF
         ESarBO5HJKn1rIznqrmIBDklyZ8fcIxk8BAHrkSA8cfW7nmCXHFMK0yQBUdJtOXuMc6E
         +9UMoQkW5vG/oQXSF+1lRP8sYiRAs2CHJRKyVteDlSqdspAOjbRjnD6LxKsJKRZcUmFD
         v4ka4lAWU8R46ua+oqs7/tNwHkYt8IbtZUy00vixqr6/Odt2dd8epcOmklNLXqVCiwr0
         S3J1vHfh6TOM/jGLrhCOv/6yOZY/MWRgnhxl4Gi6uwz7pw4dWBKrKMTMsg4acpaPx6pW
         gzXA==
X-Gm-Message-State: AAQBX9eJhQuvPmjkRc1aj9V9kklNk3cabm3RZIM0Unzlx7fGAeqkE6LN
        6KA8yqWhKeQa1+ai0CiovL9HszG4pQw=
X-Google-Smtp-Source: AKy350achO7yBBHY3i1RX2ALfxLSKSazvUmhK6EsZVAmKRqUVvWLVw7J9uuGthMisnkw+b8AjkYEJPH0lZQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce81:b0:1a1:c945:4b2c with SMTP id
 f1-20020a170902ce8100b001a1c9454b2cmr174107plg.7.1679609531428; Thu, 23 Mar
 2023 15:12:11 -0700 (PDT)
Date:   Thu, 23 Mar 2023 15:12:09 -0700
In-Reply-To: <20230301053425.3880773-8-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230301053425.3880773-1-aaronlewis@google.com> <20230301053425.3880773-8-aaronlewis@google.com>
Message-ID: <ZBzOuZV7q1wF78h5@google.com>
Subject: Re: [PATCH 7/8] KVM: selftests: Add string formatting options to ucall
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023, Aaron Lewis wrote:
> Add more flexibility to guest debugging and testing by adding
> GUEST_PRINTF() and GUEST_ASSERT_FMT() to the ucall framework.
> 
> A buffer to hold the formatted string was added to the ucall struct.
> That allows the guest/host to avoid the problem of passing an
> arbitrary number of parameters between themselves when resolving the
> string.  Instead, the string is resolved in the guest then passed
> back to the host to be logged.
> 
> The formatted buffer is set to 1024 bytes which increases the size
> of the ucall struct.  As a result, this will increase the number of
> pages requested for the guest.

Why 1024?  I don't particuarly have an opinion, but some explanation of where this
magic number comes from would be helpful.
 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../selftests/kvm/include/ucall_common.h      | 19 +++++++++++++++++++
>  .../testing/selftests/kvm/lib/ucall_common.c  | 19 +++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 0b1fde23729b..2a4400b6761a 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -13,15 +13,18 @@ enum {
>  	UCALL_NONE,
>  	UCALL_SYNC,
>  	UCALL_ABORT,
> +	UCALL_PRINTF,
>  	UCALL_DONE,
>  	UCALL_UNHANDLED,
>  };
>  
>  #define UCALL_MAX_ARGS 7
> +#define UCALL_BUFFER_LEN 1024
>  
>  struct ucall {
>  	uint64_t cmd;
>  	uint64_t args[UCALL_MAX_ARGS];
> +	char buffer[UCALL_BUFFER_LEN];
>  
>  	/* Host virtual address of this struct. */
>  	struct ucall *hva;
> @@ -32,6 +35,7 @@ void ucall_arch_do_ucall(vm_vaddr_t uc);
>  void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>  
>  void ucall(uint64_t cmd, int nargs, ...);
> +void ucall_fmt(uint64_t cmd, const char *fmt, ...);
>  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>  void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
>  int ucall_header_size(void);
> @@ -47,6 +51,7 @@ int ucall_header_size(void);
>  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>  #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
> +#define GUEST_PRINTF(fmt, _args...) ucall_fmt(UCALL_PRINTF, fmt, ##_args)
>  #define GUEST_DONE()		ucall(UCALL_DONE, 0)
>  
>  enum guest_assert_builtin_args {
> @@ -56,6 +61,18 @@ enum guest_assert_builtin_args {
>  	GUEST_ASSERT_BUILTIN_NARGS
>  };
>  
> +#define __GUEST_ASSERT_FMT(_condition, _condstr, format, _args...)	\
> +do {									\
> +	if (!(_condition))						\
> +		ucall_fmt(UCALL_ABORT,					\
> +		          "Failed guest assert: " _condstr		\
> +		          " at %s:%ld\n  " format, 			\

Please don't wrap strings, especially not in macros.  Just run past 80 chars if necessary.

> +			  __FILE__, __LINE__, ##_args);			\
> +} while (0)
> +
> +#define GUEST_ASSERT_FMT(_condition, format, _args...)	\
> +	__GUEST_ASSERT_FMT(_condition, #_condition, format, ##_args)
> +
>  #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...)		\
>  do {									\
>  	if (!(_condition))						\
> @@ -81,6 +98,8 @@ do {									\
>  
>  #define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)
>  
> +#define REPORT_GUEST_ASSERT_FMT(_ucall) TEST_FAIL("%s", _ucall.buffer)
> +
>  #define __REPORT_GUEST_ASSERT(_ucall, fmt, _args...)			\
>  	TEST_FAIL("%s at %s:%ld\n" fmt,					\
>  		  (const char *)(_ucall).args[GUEST_ERROR_STRING],	\
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index b6a75858fe0d..92ebc5db1c41 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -54,7 +54,9 @@ static struct ucall *ucall_alloc(void)
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>  		if (!test_and_set_bit(i, ucall_pool->in_use)) {
>  			uc = &ucall_pool->ucalls[i];
> +			uc->cmd = UCALL_NONE;

This is unnecessary, there's one caller and it immediately sets cmd.  If it's a
sticking point, force the caller to pass in @cmd and move the WRITE_ONCE() here.
Oh, and if you do that, put it in a separate patch.

>  			memset(uc->args, 0, sizeof(uc->args));
> +			memset(uc->buffer, 0, sizeof(uc->buffer));
>  			return uc;
>  		}
