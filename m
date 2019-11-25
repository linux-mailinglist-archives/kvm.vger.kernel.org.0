Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EEA1093F3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 20:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfKYTHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 14:07:36 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:37734 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfKYTHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 14:07:36 -0500
Received: by mail-il1-f193.google.com with SMTP id s5so15237271iln.4
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2019 11:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uxg5HUbuTNPv9TZS2m101TfjoAcQvznXZTZhO4Sew/M=;
        b=YcVMb1LRVpwa6yTgLQyEh5/k5v9KJIQqzG+ilyfQm7G+taD6dWwghScTobFhZqm6oy
         eoZWyL79itbjaPV8niFxl3xN2KSZdY6VGbCS0sLvtLA5GfpJMXeTFotFYv7mklb7d34/
         K+IhdHe94oIErw5pVUpoLK4gdqANMJCyExr8Qx0V9DhTH8CIFh8iX4SrBbryW96nMYHU
         MCOepLPfTvzgQdx+eZIgcl1S5zgJynSyLANVX15Rm400zIGGMBNgdVuIswbU5JrLC3m6
         gpYLV2UByG9ArDO9d3sahz0j49ahMLIJ2Kxi7bqsNsUzmwgSP21ckqIvF23zTG0wmlYV
         0K8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uxg5HUbuTNPv9TZS2m101TfjoAcQvznXZTZhO4Sew/M=;
        b=cwo2+MhDbdfWoGJEf6Zvmr+DISFPXmsj/FR6UtgSaZ68r2A+ODyAtkz6fwgJE5Uizx
         qWPrep/1hbdGfFaxbdmscx7NrQG5Z/kYXbzz1qSOU4PdGtgkBTpXaiM5g59okXscTH7q
         lXFvSLHQsOw94pBA61sUraExyGLttoxrh5s7ac3mtA5JuUPioa/UdGyuwds0SB9ow78s
         MxVNXZ2WqRbJvzc+xubayMty5W7iumJMVZPL9A4zrBlyPuAF+2RRMF16DaC1nnZiU9A8
         WBbv5jqg4Hzoe4JhKTVwF+KZwElhODAuWDlNQ8rtZIf9+lK0IT8BESJhKnzK3qYB6iJt
         ig/Q==
X-Gm-Message-State: APjAAAXbe3IRFEfHrj/MOlD+sKw0Z57klYFdcucUgMtRZUm7uIkeHHUe
        RY62vAYPMUQmyw4SS3YhkmN8SOQb/TBGvZ8vAmP6jA==
X-Google-Smtp-Source: APXvYqwMpr1hW/rwgUerZPkyrHN4UTM1+E1/N6RPpLYJoWfa0agGgCpfc5HP0OGYjfDrtGgK4Pw6KcNy6Lq/IT0Ug84=
X-Received: by 2002:a92:c981:: with SMTP id y1mr33566633iln.53.1574708854881;
 Mon, 25 Nov 2019 11:07:34 -0800 (PST)
MIME-Version: 1.0
References: <20190710201244.25195-1-brijesh.singh@amd.com> <20190710201244.25195-9-brijesh.singh@amd.com>
In-Reply-To: <20190710201244.25195-9-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 25 Nov 2019 11:07:23 -0800
Message-ID: <CAMkAt6ouYHH6tg=SrGLoh1kEua2BY+WksaM0oRhVTW-i64rTaA@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS hypercall
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 3089942f6630..431718309359 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -135,6 +135,8 @@ struct kvm_sev_info {
>         int fd;                 /* SEV device fd */
>         unsigned long pages_locked; /* Number of pages locked */
>         struct list_head regions_list;  /* List of registered regions */
> +       unsigned long *page_enc_bmap;
> +       unsigned long page_enc_bmap_size;
>  };
>

Just a high level question. Would it be better for these bitmaps to
live in kvm_memory_slot and the ioctl to be take a memslot instead of
a GPA + length? The c-bit status bitmap will probably need to be
checked at when checking the dirty log and KVM_GET_DIRTY_LOG
operations on memslots.
