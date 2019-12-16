Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137ED1206B4
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 14:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfLPNLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 08:11:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58163 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727795AbfLPNLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 08:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576501903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGy7hA1R/Ff1cUj5iexZAw7T35hQcQ6yTVuO7Q49ddg=;
        b=XA/jlcJCHSFt6U3XFIbPgZ8HPs1FdC2IQxHjuJImKNpH6kWjoM6XM31zkazfXwpiizFIVK
        0q8FdFgCb2XgZ7/uxC+L0qnd/MarZiZXscywEBNrYTxW7VPS8n9MM9+g98MJgtb7Fl38vZ
        fOr0HH4eEv00pWJUxhcIMlfKXQMORuA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-04QWH7MSP--lWIQTVe1k3Q-1; Mon, 16 Dec 2019 08:11:41 -0500
X-MC-Unique: 04QWH7MSP--lWIQTVe1k3Q-1
Received: by mail-wr1-f71.google.com with SMTP id y7so2348261wrm.3
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 05:11:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GGy7hA1R/Ff1cUj5iexZAw7T35hQcQ6yTVuO7Q49ddg=;
        b=PznJmiI4rSTA1ff226r41/qwUqh3nQOkZBibIxdp1+rLUNuVM5ZU1Mu8bkozyRYAdf
         TePdgMaFRO53G10lW4/GYrcv1zfDbQcRzNIbvh/R/ZgZdLV3g9sJIFM0NCwEpjakMTFJ
         MC4M+sl/O8US/XxJec+KFOex02hVJcwY1c2UZIvs7TSVoTjOf5UoiC2ZM8amMGmhIhJk
         N5Z1RnE33UqRK/CU+XvH5bPOwhSgMKGTFpRMVUpNqnf3jP5ANxVKyZTFuVJ8CdH4oIpd
         d7UXMsTkE1keV8IKEsAeMcfVc82vZMKkglNm3jD2nDdCQid2KuJZHHT0AONIDNAmf+8d
         Tb/g==
X-Gm-Message-State: APjAAAVIPnMnzxKE4w74YTHJmtIbzIx04VdaskbTrVTYiRra1p5bpSog
        +z/yUF9/RDXvMv7odZz7E++Z38pHz5/FYe98YfRRJDvePNmjZ/RXK2q5JXrwvex58QxES8T5lx/
        O53N7Dlbj0Ea8
X-Received: by 2002:adf:e5ce:: with SMTP id a14mr29446736wrn.214.1576501900355;
        Mon, 16 Dec 2019 05:11:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGHJubMRcjF3rMhfF0ZkDV3XSz2Wf97J4Nphi2H0AX4FuSFFoF7H4ntveSXYPOaUHPW1jkNg==
X-Received: by 2002:adf:e5ce:: with SMTP id a14mr29446705wrn.214.1576501900156;
        Mon, 16 Dec 2019 05:11:40 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id z21sm21002520wml.5.2019.12.16.05.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 05:11:39 -0800 (PST)
Subject: Re: [PATCH 07/12] hw/ide/piix: Remove superfluous DEVICE() cast
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org, Sergio Lopez <slp@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
 <20191213161753.8051-8-philmd@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6ea21857-7304-1016-2bd4-d2beb2b75551@redhat.com>
Date:   Mon, 16 Dec 2019 14:11:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213161753.8051-8-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/12/19 17:17, Philippe Mathieu-Daudé wrote:
> Commit 02a9594b4f0 already converted 'dev' to DeviceState.
> Since the cast is superfluous, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/ide/piix.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/ide/piix.c b/hw/ide/piix.c
> index db313dd3b1..ffeff4e095 100644
> --- a/hw/ide/piix.c
> +++ b/hw/ide/piix.c
> @@ -193,7 +193,8 @@ int pci_piix3_xen_ide_unplug(DeviceState *dev, bool aux)
>              blk_unref(blk);
>          }
>      }
> -    qdev_reset_all(DEVICE(dev));
> +    qdev_reset_all(dev);
> +
>      return 0;
>  }
>  
> 

Queued, thanks.

Paolo

