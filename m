Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2042BFD004
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 22:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKNVCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 16:02:41 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34802 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfKNVCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 16:02:40 -0500
Received: by mail-io1-f66.google.com with SMTP id q83so8476501iod.1
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 13:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yJBKOKwM5iW599/3PXPapFgko2uf1vvK5qJNHvXkEvA=;
        b=m6pquKxI4tETRrClr728OIAj7DTVhy29VH8PJJnNux08Ye4bolkgPRVFsBD8+AXlgf
         GdR+UACzBDaQs+1VNv5McBiMGmHUPYhI7e3StEwAuoQLoxndNoy7eUwosL0ZwCc2g/IF
         XRCjKwRaprlcahHNv4vCZMnn1mC36vklMsd1uEwVUWw5eL2+PixU+6dB/TPgTSa2Mx7H
         W7OdSU6Aqa0vqFD95FOoR9vq+w9gh0BdFS5jX+LHTokw6qXIvpnIEWZ55jDn8iuAmx03
         56S9vmiD0TQGGRoqIZvjMszL3KZzq82MAgu1AANUsopCj8I91sp+yLlnYV7dIYpQpca8
         FT/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yJBKOKwM5iW599/3PXPapFgko2uf1vvK5qJNHvXkEvA=;
        b=BEtlIv34HuJKMl8YX71UOs3TzAy31zSC/pYTf/drieVj3M8l5Jt1w5nwowSxJQ73Dc
         7sN5gQY9cV+tye6e2xHTxX2WH3zcS7X5WzHytiE8s54LZPiW5SswCuZhVebpS/1lLaAE
         csBl+9ALjI+tS+9zBTCEvpV4ubMlsZZa/CLtO7O3By1JLe5dR3BJrwWh7UYNRHa7Tdmt
         IzqSwnjsahlRM5PU+WoJJhu3/A3U7QUwtA99Cm9/wYhObmePrFBGIHYd/Gi+GvgtYIp7
         9ue6LwgrzFbcwHfiPxv4kgxh4lipm7fnTAIWbeJbB1EsdtJj3zA4DIp6/nycs4bZaVeV
         6bNA==
X-Gm-Message-State: APjAAAVSCQhneBD5YPty2NX1899Is1+Hcz522mU1O3kWP3qflPKpzVXh
        g6ILJrOdmQV0itSe+gcZUrTc3g81+RzSoVvg8mCieQ==
X-Google-Smtp-Source: APXvYqxynaYSurYk47xcjrOqbqAQBuVKxdYBSiGXLLrIBieS6FdrGnE361Q6RfBMXentbWd450Oxj+nrUALkwZBgnjc=
X-Received: by 2002:a6b:8d8f:: with SMTP id p137mr822567iod.53.1573765359791;
 Thu, 14 Nov 2019 13:02:39 -0800 (PST)
MIME-Version: 1.0
References: <20190710201244.25195-1-brijesh.singh@amd.com> <20190710201244.25195-6-brijesh.singh@amd.com>
In-Reply-To: <20190710201244.25195-6-brijesh.singh@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 14 Nov 2019 13:02:28 -0800
Message-ID: <CAMkAt6rwbq6XC_K64arBUmqsTzSWk7Zoazq-YcqLvjc-rmW8BA@mail.gmail.com>
Subject: Re: [PATCH v3 05/11] KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
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

> +
> +       /* Check if we are crossing the page boundry */
> +       offset = params.guest_uaddr & (PAGE_SIZE - 1);
> +       if ((params.guest_len + offset > PAGE_SIZE))
> +               return -EINVAL;

Just curious spec only says that "System physical of the guest memory
region. Must be 16 B aligned with the C-bit set." and "Length of guest
memory region. Must be a multiple of 16 B and no more than 16 kB". Why
do we want to avoid crossing a page boundary?

Also is there an overflow concern in the conditional because
params.guest_len is not checked before this?

> +
> +       data = kzalloc(sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
> +       if (IS_ERR(hdr)) {
> +               ret = PTR_ERR(hdr);
> +               goto e_free;
> +       }
> +
