Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CF46D4E6F
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbjDCQyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232599AbjDCQyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:54:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABDA172C
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:53:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 126-20020a630284000000b005135edbb985so7095497pgc.1
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680540834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AQHtiaCr5zf+/2dE6tPKsinrdFSv61OsLIPc2I0kjmM=;
        b=S6ZXFmVGzUfar1jnHWoUL0GQBFpKe8gEnlvVSxvWcCByELCHSM5PLNHtAliqZX08eO
         1AXf6nWG8KBERsSgyCmAApbYcR5wncHYrEOX01jL8pUuOy/ZIVorCiDGvr1RuiGfynaX
         xz9CTQOYBPAJBGQk9SUSU1bKQfbiPXLzwpLGh58WZQVCLMwlNeUe9+vQ2S3knhD6VcsJ
         y6uNEVpWOK+XwMkV+2DRtsnOHzWdOTK4ZOZvuikjIpGZ7tzF1eqd55nxQPKFI7EER2FS
         zhc+pokHGxr+ejJhQgJ6uv+Y8S9z5faStCJCLfIKVuAFxUmcOxTnn2SkQsa49QPdPxak
         /Vzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680540834;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQHtiaCr5zf+/2dE6tPKsinrdFSv61OsLIPc2I0kjmM=;
        b=wsqqoJMK4hL9U2wtVLIrFL7i+3pphA9ndTOZboK/m8jpjluiQJfSFWXcv5LxJhLePf
         zYzxi3XQCMgxgz1eSIOmpRHKo4Zn9W+SAlklGuCmtlfLsxx/Ckn12evbJhMRZoYuaenU
         PVMDhm/pETExQW5l9SkFKwkHSMyjJUmDGPqCWGr2YE24vO27N3f/6p1T39EpThshKk9H
         dF3Gmf1wDWTW6oqhT76eg9DH/qrWG0Ap05q/1nY494TMxjMvL8zmKVtYQPEYsRzGXSvG
         kQ3cDKNUJBqt3qa2SRaP4/GE8pV2S+9dGLkgXJQrHIP1FYKVZwJmzvLLmSgOJ5AGPBN/
         DOpw==
X-Gm-Message-State: AAQBX9eJD6ubKtjt2sQCNAVSZqn2w6ZPXCbNNKuYP9t99hlOdQqOCmez
        +UnZqoQd8hMkC0+G3Y3P4YfpfgmpWVA=
X-Google-Smtp-Source: AKy350YWGHmnu8mFcQ7Xf2+u+PnKY5NyvUfxaTsydde5r+/FQ/xdAsvwb1jDWzp5lXyP3YbbRtXxTzbbSTI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8bc4:b0:19f:1d62:4393 with SMTP id
 r4-20020a1709028bc400b0019f1d624393mr12242523plo.7.1680540834031; Mon, 03 Apr
 2023 09:53:54 -0700 (PDT)
Date:   Mon, 3 Apr 2023 09:53:52 -0700
In-Reply-To: <20230403164411.388475-1-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20230403164411.388475-1-pbonzini@redhat.com>
Message-ID: <ZCsEoLRT4Y+Tumaa@google.com>
Subject: Re: [PATCH kvm-unit-tests v2] memory: Skip tests for instructions
 that are absent
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
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

On Mon, Apr 03, 2023, Paolo Bonzini wrote:
> Checking that instructions are absent is broken when running with CPU
> models other than the bare metal processor's, because neither VMX nor SVM have
> intercept controls for the instructions.
> 
> This can even happen with "-cpu max" when running under nested
> virtualization, which is the current situation in the Fedora KVM job
> on Cirrus-CI:
> 
> FAIL: clflushopt (ABSENT)
> FAIL: clwb (ABSENT)
> 
> In other words it looks like the features have been marked as disabled
> in the L0 host, while the hardware supports them.
> 
> Reported-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/memory.c | 83 +++++++++++++++++++++++++++++++---------------------
>  1 file changed, 49 insertions(+), 34 deletions(-)
> 
> diff --git a/x86/memory.c b/x86/memory.c
> index 351e7c0..58ef835 100644
> --- a/x86/memory.c
> +++ b/x86/memory.c
> @@ -25,53 +25,68 @@ static void handle_ud(struct ex_regs *regs)
>  
>  int main(int ac, char **av)
>  {
> -	int expected;
> -
>  	handle_exception(UD_VECTOR, handle_ud);
>  
>  	/* 3-byte instructions: */
>  	isize = 3;

We can clean this up even further by utilizing TRY_ASM().  Though I think this is
a good excuse to add things like asm_safe(), asm_safe_report(), and asm_safe_report_ex(),
to cut down on the boilerplate even more.  I'll send patches on top.
