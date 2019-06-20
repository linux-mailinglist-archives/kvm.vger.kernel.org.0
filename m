Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7C84D22E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfFTPbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 11:31:19 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39173 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfFTPbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 11:31:18 -0400
Received: by mail-qt1-f196.google.com with SMTP id i34so3587796qta.6
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 08:31:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4XM6fArIUsV/+pZkhNcBinvKGNGJit6kYMRWjAvyWFE=;
        b=BS3R7xNJ3yRGrYE0+Z2laItFTgk9X2DEUdx3q77cU83+l42RX5apHZ1ZJb9SImzKA8
         /6K/o5QMqricH/0z/G7Nu1EeH5JdEX4J5etRQSHhHmL24YgovK/t8zwGLMwS9Wb49km1
         Q82rIrltI9btuX1f2GtC1OR2c5mZcyRpq7TzZKAKW7FhDOO42FLnZZAOwQU+Yo+8z3og
         FsAXRv22AuaoW+LXvdBbSAwC4faUANUUjdAaBFj36yabrh6OWXyPp7Kmps/ewE8NrsIi
         u1v0Ltj1ZhQui0kk7fRKZjdMhwdBnjgdIlmUl1CxfCyfifM2AzBTBwKwvMApgftVzaSc
         inYQ==
X-Gm-Message-State: APjAAAX9DZCrCcCOXPEajGpNATEId/2VzRbh/2GvMSNAxhGdZ4Uvkrza
        B7COvv8ZEvTn3fjpnr/mnlxfiw==
X-Google-Smtp-Source: APXvYqzlLc1a02kX0TMAY2AR0gScGuRHJJ9T1TVoHK3QN7iau25wMPt8qzcI/8HL92pN2hP6+HBG3w==
X-Received: by 2002:aed:3c2e:: with SMTP id t43mr114614953qte.39.1561044678015;
        Thu, 20 Jun 2019 08:31:18 -0700 (PDT)
Received: from redhat.com (173-166-0-186-newengland.hfc.comcastbusiness.net. [173.166.0.186])
        by smtp.gmail.com with ESMTPSA id r39sm16438930qtc.87.2019.06.20.08.31.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:31:17 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:31:15 -0400
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
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 04/20] hw/i386/pc: Add the E820Type enum type
Message-ID: <20190620112913-mutt-send-email-mst@kernel.org>
References: <20190613143446.23937-1-philmd@redhat.com>
 <20190613143446.23937-5-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613143446.23937-5-philmd@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 13, 2019 at 04:34:30PM +0200, Philippe Mathieu-Daudé wrote:
> This ensure we won't use an incorrect value.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

It doesn't actually ensure anything: compiler does not check IIUC.

And OTOH it's stored in type field in struct e820_entry.

> ---
> v2: Do not cast the enum (Li)
> ---
>  hw/i386/pc.c         |  4 ++--
>  include/hw/i386/pc.h | 16 ++++++++++------
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 5a7cffbb1a..86ba554439 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -872,7 +872,7 @@ static void handle_a20_line_change(void *opaque, int irq, int level)
>      x86_cpu_set_a20(cpu, level);
>  }
>  
> -ssize_t e820_add_entry(uint64_t address, uint64_t length, uint32_t type)
> +ssize_t e820_add_entry(uint64_t address, uint64_t length, E820Type type)
>  {
>      unsigned int index = le32_to_cpu(e820_reserve.count);
>      struct e820_entry *entry;
> @@ -906,7 +906,7 @@ size_t e820_get_num_entries(void)
>      return e820_entries;
>  }
>  
> -bool e820_get_entry(unsigned int idx, uint32_t type,
> +bool e820_get_entry(unsigned int idx, E820Type type,
>                      uint64_t *address, uint64_t *length)
>  {
>      if (idx < e820_entries && e820_table[idx].type == cpu_to_le32(type)) {
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index c56116e6f6..7c07185dd5 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -282,12 +282,16 @@ void pc_system_firmware_init(PCMachineState *pcms, MemoryRegion *rom_memory);
>  void pc_madt_cpu_entry(AcpiDeviceIf *adev, int uid,
>                         const CPUArchIdList *apic_ids, GArray *entry);
>  
> -/* e820 types */
> -#define E820_RAM        1
> -#define E820_RESERVED   2
> -#define E820_ACPI       3
> -#define E820_NVS        4
> -#define E820_UNUSABLE   5
> +/**
> + * E820Type: Type of the e820 address range.
> + */
> +typedef enum {
> +    E820_RAM        = 1,
> +    E820_RESERVED   = 2,
> +    E820_ACPI       = 3,
> +    E820_NVS        = 4,
> +    E820_UNUSABLE   = 5
> +} E820Type;
>  
>  ssize_t e820_add_entry(uint64_t, uint64_t, uint32_t);
>  size_t e820_get_num_entries(void);
> -- 
> 2.20.1
