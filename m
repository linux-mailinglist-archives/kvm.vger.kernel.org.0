Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F1B16189F
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgBQRPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:15:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728059AbgBQRPy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 12:15:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=So9XPv62WRRlQlobfjbv7DGM07vzxCapcWtJuCnxFtQ=;
        b=J/gdLYXDrdFqP63s11JHB+M+yMo+e7jPxmfqR55S1v5ki5pSbp1ML+ta68HhwPEObA+uyq
        nbhAF3IqPPVk+uQkNBtUW90dkad8aIscVtz/fbv30A3qSqY5j33oIDKrksk9nttdf4qfYN
        AY18T3Ts7Nq6aDy2tkgokkiY0y9VS5E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-mHCqsTSkMMSJI_6IHJRpFQ-1; Mon, 17 Feb 2020 12:15:51 -0500
X-MC-Unique: mHCqsTSkMMSJI_6IHJRpFQ-1
Received: by mail-wr1-f69.google.com with SMTP id z15so9307156wrw.0
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=So9XPv62WRRlQlobfjbv7DGM07vzxCapcWtJuCnxFtQ=;
        b=VIgl9mEfr+cpMl4aRoqFHKbxyfh3o9+58UITFsAvgs+xOVvwTLHqBi4yftRtSHAyTV
         JFPPHGznR4d85VVWHjRdixuBIXROeSlj/iY5PwvghQSvdVIUwkwzU0YBsVjz0vKJNdX4
         1JmbKl+NSyybUU7BDOeTZ22nn6gllrC20yEpbGgcov1OyeKbsSd0nRsVt3BG+9R1EEmN
         y1feQ4Z29nk4RNd8qKzSH6T97OlyAVukL7QPnilFadsnf6+A2iWqRFRAQw+PDwzw4zFj
         W61QExIFCPoTgQFVkR7Po/ttBx/oJuwYoyrY9GYpTrGh6lJUovqwXRdUDxeoUwvEMzVz
         sLPg==
X-Gm-Message-State: APjAAAV+GbEsYLEpc0wmr4e+PicsyV7DNpP9SGVyr0p/TDzWWHbwhW11
        tkHh+N+2CnMJqdE7FtlAT8B3TCVPtzLqvk2SlZdf8+NU9K2jDwgbJONyeK4WXfKyc5d4thDmZWP
        B/+MNR6ved5oV
X-Received: by 2002:a1c:9646:: with SMTP id y67mr73760wmd.42.1581959750543;
        Mon, 17 Feb 2020 09:15:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqz7y8IWxspRQy16pPYhFQi9maKhxPLla3Ezv35ZwrJ/KCJ6PiM5kALcG5Usi+8wrJWxGKchZQ==
X-Received: by 2002:a1c:9646:: with SMTP id y67mr73732wmd.42.1581959750239;
        Mon, 17 Feb 2020 09:15:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id x17sm1883439wrt.74.2020.02.17.09.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 09:15:49 -0800 (PST)
Subject: Re: [PATCH] KVM: Add the check and free to avoid unknown errors.
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <aaac4289-f6b9-4ee5-eba3-5fe6a4b72645@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <33cd2fda-f863-82be-5711-8c9e4eaa7971@redhat.com>
Date:   Mon, 17 Feb 2020 18:15:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <aaac4289-f6b9-4ee5-eba3-5fe6a4b72645@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 22:02, Haiwei Li wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
> 
> If 'kvm_create_vm_debugfs()' fails in 'kzalloc(sizeof(*stat_data), ...)',
> 'kvm_destroy_vm_debugfs()' will be called by the final fput(file) in
> 'kvm_dev_ioctl_create_vm()'.

Can you explain better?  It is okay to pass NULL to kfree.

Paolo

> Add the check and free to avoid unknown errors.
> 
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>  virt/kvm/kvm_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ae2d5..18a32e1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -617,8 +617,11 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
>      debugfs_remove_recursive(kvm->debugfs_dentry);
> 
>      if (kvm->debugfs_stat_data) {
> -        for (i = 0; i < kvm_debugfs_num_entries; i++)
> +        for (i = 0; i < kvm_debugfs_num_entries; i++) {
> +            if (!kvm->debugfs_stat_data[i])
> +                break;
>              kfree(kvm->debugfs_stat_data[i]);
> +        }
>          kfree(kvm->debugfs_stat_data);
>      }
>  }
> -- 
> 1.8.3.1
> 

