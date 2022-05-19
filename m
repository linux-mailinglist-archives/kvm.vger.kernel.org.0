Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B604452CA77
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 05:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbiESDlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 23:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiESDld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 23:41:33 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16D661299;
        Wed, 18 May 2022 20:41:31 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id v65so5030513oig.10;
        Wed, 18 May 2022 20:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:content-language:to
         :cc:references:from:subject:in-reply-to:content-transfer-encoding;
        bh=E+Jeeum5dAYeu7JrVKgmUScX8K6q6nSaD3V1Uo7Z0xo=;
        b=KFjvSCT6GXj5Kr0HO4phTFW0x5Mhrxpol/LwndM9mgk+gt2L/LZ/5khjHvxx9tCYCl
         ccDkePOGAv4JpJmRo0Xqzh6ClQpZnN/1/b7sQl4OHAEBLezdGI2XWE9/o/Z1OZFdJplA
         hvInyanC3HKTFBbmtIho+sxxjhNvtMvXN/SpDUcK6pzwbtXhkX4B8r6bM063uhwPRf2Y
         cRgCWW0s7tOlAD3+MsxhCIYV0WDd/vE6gTqXbb2/O3YdWrgPTUK3f0QWoOCgnNy5j+zJ
         Pm+2UwK0eLGDknVSYV48h5O6crlLJ0idezAZuMW3TB+ty1IBtVt29pHwTXbVrYvZnNon
         S1IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=E+Jeeum5dAYeu7JrVKgmUScX8K6q6nSaD3V1Uo7Z0xo=;
        b=EtZhacL/d18FgsjrPbP9gxyZELnbKYYaNtw7UuaOJx/brlb9fcpMmwOuF+GiTZenp8
         fey8HZRxPh0kSt7wffo6dU+r08h0zE6cDa5R280j3kxA6BJTOCkgEWCeM5LhR1Y0maAy
         ggHDh0UpExM1Sr3yl8gw3lBMrXR6ITp2UZpcGBsh4a69fL/ley4JuPEcizN0acZ15PhN
         9zXi6DITCuSyWRQ1ACEQB+JVLmxdPdJdafWMuYKLIegpRFlA9R9spvmKZu+vq5TXqkRJ
         SAQQTF+m3Scj5qD6OuHD9/C8ggkE9rTUji5TFwKXGWUhz8e4fabgzWem6+2m+0ij5kfM
         g/IA==
X-Gm-Message-State: AOAM531/coR7asKGSwU72tEuTg4HuwM2zYawY60B08nSnijGw1whHHLS
        E1ipsCCvo6oZacnHqIljgBo=
X-Google-Smtp-Source: ABdhPJzNbyvmXREi3jFpQ1BXha9I4ZZcQvTagfhdtbiKBgx1gr2M0BpSR/Ospfm2JXh/HEBEZ+zfpQ==
X-Received: by 2002:aca:4154:0:b0:322:7a9c:7daa with SMTP id o81-20020aca4154000000b003227a9c7daamr1784072oia.52.1652931691271;
        Wed, 18 May 2022 20:41:31 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p4-20020aca4204000000b0032694a9925esm1451284oia.10.2022.05.18.20.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 20:41:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <0530d502-1291-23f3-64ac-97bd38a26bd4@roeck-us.net>
Date:   Wed, 18 May 2022 20:41:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-staging@lists.linux.dev, linux-omap@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-hwmon@vger.kernel.org,
        linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
References: <6285958d.+Z2aDZ4O1Y9eiazd%lkp@intel.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [linux-next:master] BUILD REGRESSION
 736ee37e2e8eed7fe48d0a37ee5a709514d478b3
In-Reply-To: <6285958d.+Z2aDZ4O1Y9eiazd%lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/22 17:55, kernel test robot wrote:
> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 736ee37e2e8eed7fe48d0a37ee5a709514d478b3  Add linux-next specific files for 20220518
> 
> Error/Warning reports:
> 
> https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205172344.3GFeaum1-lkp@intel.com
> https://lore.kernel.org/linux-mm/202205190527.o9wVEvHI-lkp@intel.com
> 
> Error/Warning: (recently discovered and may have been fixed)
> 
[ .. ]
> drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
> drivers/hwmon/nct6775-platform.c:199:9: sparse:    void

This is getting tiresome. Every driver using outb() on m68k will
experience that "problem". As far as I can see, it is caused by

#define out_8(addr,b) (void)((*(__force volatile u8 *) (unsigned long)(addr)) = (b))

in arch/m68k/include/asm/raw_io.h. I have no idea what the
"(void)" is for, but removing it "fixes" the problem.
Either case, this is not a problem with the nct6775 driver,
nor is it a new problem.

Guenter
