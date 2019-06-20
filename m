Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE74D222
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 17:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfFTP1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 11:27:55 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36363 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfFTP1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 11:27:54 -0400
Received: by mail-qt1-f193.google.com with SMTP id p15so3606711qtl.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 08:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JAcKHy1FRAtW0JEnhHKGbjx3Sy0ZWxrGVRh9A8UVyZY=;
        b=rNI9U6cvH2o7Tnoavstyd6N/8Qp8M7UNG7tfBOZSDNNS/wkdnMAinO3nuEaEwmIIKQ
         7MHpmOSxCFI9n3dTG10fNITeFAiQ/WDg3wPw7Tw05eoQCFNrqZxlZnJGP8ScHNkPbL7y
         vkdqSmHDfKDR/Eh6o4J8i2Jt6Ivl0vmMbQqmXXF7BrWKpddPqgZ32gAbvtUwm+jriiJr
         e7mjCVkgfzGLpsJHM6eVTWhQTSK0Hv6hU5M1Riw8/B2i7wg/pAt3dboNA9VH54hOTG9w
         itSE8XOUJjL7j5+l/54rbimYQzfqMRHizEAt71cgaCrHvieL0OVVwOCXazBfPGWswUsL
         1xQA==
X-Gm-Message-State: APjAAAU4nRYefBVs8oX4xZXHMt/GJNa2oghX1tRHSF6KS66rqGSEwh7v
        W7XM4fH1bZ6Nqf6a4uuDFN+Z7pmK/QElBA==
X-Google-Smtp-Source: APXvYqxpLs2C5Gy8h4gWf0WS9cA4AFjodndt+QmKZvo4EmyB20KX1/URQU2oRJ3ithnPgGiwltjNCQ==
X-Received: by 2002:ac8:70cf:: with SMTP id g15mr106409493qtp.254.1561044474136;
        Thu, 20 Jun 2019 08:27:54 -0700 (PDT)
Received: from redhat.com ([64.63.146.106])
        by smtp.gmail.com with ESMTPSA id e18sm1247qkm.49.2019.06.20.08.27.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:27:53 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:27:50 -0400
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
Subject: Re: [PATCH v2 01/20] hw/i386/pc: Use unsigned type to index arrays
Message-ID: <20190620112729-mutt-send-email-mst@kernel.org>
References: <20190613143446.23937-1-philmd@redhat.com>
 <20190613143446.23937-2-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613143446.23937-2-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 04:34:27PM +0200, Philippe Mathieu-Daudé wrote:
> Reviewed-by: Li Qiang <liq3ea@gmail.com>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

Motivation?  Is this a bugfix?


> ---
>  hw/i386/pc.c         | 5 +++--
>  include/hw/i386/pc.h | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 2c5446b095..bb3c74f4ca 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -874,7 +874,7 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
>  
>  int e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
>  {
> -    int index = le32_to_cpu(e820_reserve.count);
> +    unsigned int index = le32_to_cpu(e820_reserve.count);
>      struct e820_entry *entry;
>  
>      if (type != E820_RAM) {
> @@ -906,7 +906,8 @@ int e820_get_num_entries(void)
>      return e820_entries;
>  }
>  
> -bool e820_get_entry(int idx, uint32_t type, uint64_t *address, uint64_t *length)
> +bool e820_get_entry(unsigned int idx, uint32_t type,
> +                    uint64_t *address, uint64_t *length)
>  {
>      if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
>          *address = le64_to_cpu(e820_table[idx].address);
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index a7d0b87166..3b3a0d6e59 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -291,7 +291,7 @@ void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>  
>  int e820_add_entry(uint64_t, uint64_t, uint32_t);
>  int e820_get_num_entries(void);
> -bool e820_get_entry(int, uint32_t, uint64_t *, uint64_t *);
> +bool e820_get_entry(unsigned int, uint32_t, uint64_t *, uint64_t *);
>  
>  extern GlobalProperty pc_compat_4_0_1[];
>  extern const size_t pc_compat_4_0_1_len;
> -- 
> 2.20.1
