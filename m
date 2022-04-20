Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9EB5091AB
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 22:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382300AbiDTU6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 16:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382298AbiDTU6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 16:58:20 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F7540E6F;
        Wed, 20 Apr 2022 13:55:32 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s137so2781506pgs.5;
        Wed, 20 Apr 2022 13:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fCKKqwYAgNFMuMZk7qFUivljqs2QZAfOtceIVZfFhSE=;
        b=bToosJticFpPUsB2CwiZtE80vfviMsd4VbanwyouG59MzWbv4bc2d9GOruhytns/PE
         VD6RGQPMKaqcgM8oYaznVMPhXSZexU5HvzNIbqDfWUW1/7t1q6oh/+2iObh/i34hXkEk
         aN2/d7orkViSkwv6GSghdgtkIHgJ81eb9Y7as984EMfDs6ZoonOlzLFyLKSFDlwIE8qo
         WD9Skk3JZMEhYZKU12LDln1LaSVWg5FdwUJcOmyOakvOiobO6OmbsTpKluW0IFRUWb1e
         FIZo6tCkN7OFxaf+3v8vuCoc1ecZS0WDeLR0nctSx8CbF/E60pqqlNhsuunthPpHACHi
         QQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fCKKqwYAgNFMuMZk7qFUivljqs2QZAfOtceIVZfFhSE=;
        b=uPOpfvK5kR7oC+TbNNTEhBA26znhm2pLIzpCIpqILIPFSpPOWfE2ilzVqTLPiUgOPA
         q3CD4L7UPQPKiWicZyvy3LT5B1ov1ybkCB1Pg5tvRWkN2CaIv4EyaWO2sMmaYJ4iN3XI
         p+fc7LmBr/2uHDfpNRk1fH+q3uZGj6w1qyFZSJon2qAFtRZfJ3H59+nBsuPehv7u5E1v
         FwjPMKo/ypWcrXLqyntKpzZiT/qoWKY6hHsx3TrMOp5Wn8Ouclc/cEJMQ7x+Xz9orhdY
         TzbuImMZDJKQiNNbeBJJcSsDMzW5L0y3oyelIE3tdLZU+kh0noh7DTbG9kU7rd8n4XnX
         L0OQ==
X-Gm-Message-State: AOAM533HN2nO2JHlsVa4fiAi0Drc1Zekau91KMuHG9XyynKPZGxms5OI
        T8U0PqnPK7gZPzRTACDbGTg=
X-Google-Smtp-Source: ABdhPJx9ESxq6+gHBspcLB5Ib9Qq71Twks0gOK23673r77ghkkU8qcV+sJvxeyi88cKdTsdWPbT5oA==
X-Received: by 2002:a65:45c5:0:b0:39c:ec64:cc16 with SMTP id m5-20020a6545c5000000b0039cec64cc16mr20915389pgr.505.1650488131741;
        Wed, 20 Apr 2022 13:55:31 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id u20-20020a056a00159400b0050a946e0548sm7545332pfk.165.2022.04.20.13.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:55:31 -0700 (PDT)
Date:   Wed, 20 Apr 2022 13:55:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v3 11/21] x86/virt/tdx: Choose to use all system RAM as
 TDX memory
Message-ID: <20220420205530.GB2789321@ls.amr.corp.intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
 <dee8fb1cc2ab79cf80d4718405069715b0d51235.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dee8fb1cc2ab79cf80d4718405069715b0d51235.1649219184.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 06, 2022 at 04:49:23PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> +/*
> + * Helper to loop all e820 RAM entries with low 1MB excluded
> + * in a given e820 table.
> + */
> +#define _e820_for_each_mem(_table, _i, _start, _end)				\
> +	for ((_i) = 0, e820_next_mem((_table), &(_i), &(_start), &(_end));	\
> +		(_start) < (_end);						\
> +		e820_next_mem((_table), &(_i), &(_start), &(_end)))
> +
> +/*
> + * Helper to loop all e820 RAM entries with low 1MB excluded
> + * in kernel modified 'e820_table' to honor 'mem' and 'memmap' kernel
> + * command lines.
> + */
> +#define e820_for_each_mem(_i, _start, _end)	\
> +	_e820_for_each_mem(e820_table, _i, _start, _end)
> +
> +/* Check whether first range is the subrange of the second */
> +static bool is_subrange(u64 r1_start, u64 r1_end, u64 r2_start, u64 r2_end)
> +{
> +	return (r1_start >= r2_start && r1_end <= r2_end) ? true : false;

nitpick:
Just "return (r1_start >= r2_start && r1_end <= r2_end)"
Maybe this is a matter of preference, though.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
