Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAD279A47D
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 09:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjIKHaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 03:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjIKHaY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 03:30:24 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DADCD1;
        Mon, 11 Sep 2023 00:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1694417414; bh=aPvXZ8bHbYLxG5l3+8llo0L+w6f6J2a8wRs7OiYuIUI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=shqai/KGP8HDVI2KnXkk1MWU62d8q4DUbdfgg6mewf1wAPxiNQUqfE8huzt+a/UPc
         r+cuoijeFnSxV8tPhUTbMTucw7TCMPhwFmUeNIn9o03BQKLiCdlAb6ZNtMqd/j4lXk
         84JonrpL9OGUuxdHwtDd4zQcbs81FTNd1MhRzEnY=
Received: from [28.0.0.1] (unknown [101.82.59.96])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 07F23600DA;
        Mon, 11 Sep 2023 15:30:12 +0800 (CST)
Message-ID: <1c66bd8b-4be7-8296-6fd8-aa206476f017@xen0n.name>
Date:   Mon, 11 Sep 2023 15:30:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v20 28/30] LoongArch: KVM: Enable kvm config and add the
 makefile
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>,
        kernel test robot <lkp@intel.com>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-29-zhaotianrui@loongson.cn>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <20230831083020.2187109-29-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/31/23 16:30, Tianrui Zhao wrote:
> [snip]
> +
> +config AS_HAS_LVZ_EXTENSION
> +	def_bool $(as-instr,hvcl 0)

Upon closer look it looks like this piece could use some improvement as 
well: while presence of "hvcl" indeed always implies full support for 
LVZ instructions, "hvcl" however isn't used anywhere in the series, so 
it's not trivially making sense. It may be better to test for an 
instruction actually going to be used like "gcsrrd". What do you think?

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

