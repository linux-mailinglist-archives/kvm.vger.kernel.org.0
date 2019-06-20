Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC344D225
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 17:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfFTP2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 11:28:37 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34044 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfFTP2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 11:28:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id m29so3634084qtu.1
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 08:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OXpyqTPfcCFAyup/Rem/hnqL4o2lUHl+0SS7S+RDPtQ=;
        b=dWXQ69PoS/NumVDRloMmAdVKXgKBuxBmEWmS7s0vy7zAQPJw4du3a5V/Y/NOaA5TcI
         qHqccgixWJ6wKytbRoWo2yyQn/VxSFJZ6iWsQoCnQAyEIpdm/y3oXBrfxTuI/sKwCX3s
         cvFigOLrTVueFbcVdOfrvNQo9D1SXLKAU99UiRWEFNOrAGC/fyVDOuNLZclK3ZUjg29a
         FXwRB5IjUonzOahp3yi1Qn4O3vBfqG/Z/zd+wWvSawIO8Uemw1rocPer239ojfKJC20u
         ThVkCdq9unPfik1NA6ZAq4o9wLhrZ4s74xu53wR2qvtQyT90ZqsGEysE37s3d2cfCH3X
         euVQ==
X-Gm-Message-State: APjAAAUyDEJFHOfkA7adPmPFuKtytyomHvFBYoefINu/fr2SxE2VO1IW
        bstHwxwf9+iE3Ddpl0QlBBi0Nw==
X-Google-Smtp-Source: APXvYqw6U+ujCDYl8JDjyAvOha99GgNxtK3nTZ98iWonOXXm4upHK15s2RBeRUfwLEN01Xt787R1xQ==
X-Received: by 2002:ac8:323a:: with SMTP id x55mr21388069qta.211.1561044515947;
        Thu, 20 Jun 2019 08:28:35 -0700 (PDT)
Received: from redhat.com ([64.63.146.106])
        by smtp.gmail.com with ESMTPSA id j66sm12441042qkf.86.2019.06.20.08.28.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:28:35 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:28:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Rob Bradford <robert.bradford@intel.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Li Qiang <liq3ea@gmail.com>
Subject: Re: [PATCH v2 02/20] hw/i386/pc: Use size_t type to hold/return a
 size of array
Message-ID: <20190620112805-mutt-send-email-mst@kernel.org>
References: <20190613143446.23937-1-philmd@redhat.com>
 <20190613143446.23937-3-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613143446.23937-3-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 04:34:28PM +0200, Philippe Mathieu-Daudé wrote:
> Reviewed-by: Li Qiang <liq3ea@gmail.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

Motivation? do you expect more than 2^31 entries?

> ---
>  hw/i386/pc.c         | 4 ++--
>  include/hw/i386/pc.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index bb3c74f4ca..ff0f6bbbb3 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -105,7 +105,7 @@ struct e820_table {
>  
>  static struct e820_table e820_reserve;
>  static struct e820_entry *e820_table;
> -static unsigned e820_entries;
> +static size_t e820_entries;
>  struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
>  
>  /* Physical Address of PVH entry point read from kernel ELF NOTE */
> @@ -901,7 +901,7 @@ int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>      return e820_entries;
>  }
>  
> -int e820_get_num_entries(void)
> +size_t e820_get_num_entries(void)
>  {
>      return e820_entries;
>  }
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index 3b3a0d6e59..fc29893624 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -290,7 +290,7 @@ void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>  #define E820_UNUSABLE   5
>  
>  int e820_add_entry(uint64_t, uint64_t, uint32_t);
> -int e820_get_num_entries(void);
> +size_t e820_get_num_entries(void);
>  bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
>  
>  extern GlobalProperty pc_compat_4_0_1[];
> -- 
> 2.20.1
