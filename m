Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDEF69B2FD
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 20:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjBQTWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 14:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBQTWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 14:22:37 -0500
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C354BEA8
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 11:22:35 -0800 (PST)
Received: from [192.168.1.18] ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id T6JUpa4e6ar8pT6JUpIrbc; Fri, 17 Feb 2023 20:22:33 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 17 Feb 2023 20:22:33 +0100
X-ME-IP: 86.243.2.178
Message-ID: <b998acdd-ed64-9b3b-0897-dfe13e9d57d3@wanadoo.fr>
Date:   Fri, 17 Feb 2023 20:22:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] KVM: Reorder fields in 'struct kvm_mmu_memory_cache'
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
References: <f9423a6ee10d91bd6bad32beefd1b96cad4d28f1.1676620879.git.christophe.jaillet@wanadoo.fr>
 <Y++uHlQz7OEOzojb@google.com>
Content-Language: fr, en-US
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <Y++uHlQz7OEOzojb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 17/02/2023 à 17:41, Sean Christopherson a écrit :
> On Fri, Feb 17, 2023, Christophe JAILLET wrote:
>> Group some variables based on their sizes to reduce hole and avoid padding.
>> On x86_64, this shrinks the size from 40 to 32 bytes.
> 
> Heh, a hair too late[*].  Unless I'm mistaken, Mathias will be sending a new
> version in the not-too-distant future.
> 
> Thanks!
> 
> [*] https://lore.kernel.org/all/Y+puefrgtqf430fs@google.com
> 

Ok, great :)

Thanks for the feed-back.

CJ
