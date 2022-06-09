Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EB4544DFE
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbiFINpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiFINpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 09:45:12 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453344C7B9
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 06:45:11 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o10so31247134edi.1
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 06:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ed6/oIZCLllEojis+iQsosuh/kXkv+SP578fE3DPXKc=;
        b=oimkxnZsl+L678UoQNfGSY5vTDcO4GHYZr4f1zTfDw7pVZ5liF8VzGqIaI9GCBvZTO
         3CTuWlLirXeBgEdpymjMjv1bQ7UchExgUVS9iIweAKNTDeliTvryCXvARLPZzEiqDxro
         Od5R72VRP/73S4QlrvpRFqZ0vTXE3uMI1UNsC7cWHcc87PFZKvDCDThfX1e5QnaLlEjK
         fa5fb6ApVwyMFS69ceOd8h8LnOII4uOzudBpCjV1Js0H3ZgqZGtkPibOJZU8H2SdEqg2
         5BC7nfMXOZubAn7ORlzGQflYVA81d9UVBb8CAKDS67YZnuxx5IAVl9K1T0gde6S8vtZz
         6I5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ed6/oIZCLllEojis+iQsosuh/kXkv+SP578fE3DPXKc=;
        b=Z8TurjMejy1NWXlIIOL6A8Fjs5U3hCZkpdrn4MgGZotiN23dKteiKRCsxieSojqVOT
         kAnpxfuQx4mel5Vy9I/niv2ch27su0iLd6OJ/5hDJ4Xs0ZIPwvyLbkOld/QqDvh2mH9E
         VH8PrwF2jFhzCQbS1Af8MsZYoReNSPSHZRmp9o9JVOxZxDkQlCrvSZ3+Zm8d8/z1AC/Q
         WrgDJIyR5GnXUipCfHtHBCBI7JMHdIavrFTa6oWL3mmBv6qTmH+QHqlI/srvcvUJzYIG
         jrH0v9IUY4FT5XacDjbHCH8JMF0aMOZR3zfscoOuP9sa6hmcWVcO5RQQsv+zkzOtGc8b
         ubwg==
X-Gm-Message-State: AOAM531urrDOrN80ryzWKekbNNIeYcowFv2Ip3DIiO3ZHBUpkWxsWh0Z
        /0Cm4uWA1eYq/w1s/WIrEzM=
X-Google-Smtp-Source: ABdhPJx9ekJg5XWvJL71onmwGgY7rgp9FgDEi17noWoYgoWaYImu1aqMVr7t8uZjEolISiOGV+ntDQ==
X-Received: by 2002:a05:6402:518d:b0:431:5487:9606 with SMTP id q13-20020a056402518d00b0043154879606mr25879763edd.177.1654782309488;
        Thu, 09 Jun 2022 06:45:09 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t26-20020a17090605da00b006fe7d269db8sm10618584ejt.104.2022.06.09.06.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 06:45:08 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <480dec7c-ccc1-c226-928d-eb16c2a09eaa@redhat.com>
Date:   Thu, 9 Jun 2022 15:45:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.19, take #1
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy3BY551VEP5D-_vj7nzhb9O_k69v99jMdjQ+OxWZpxzpA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy3BY551VEP5D-_vj7nzhb9O_k69v99jMdjQ+OxWZpxzpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/9/22 07:20, Anup Patel wrote:
> 1) Typo fix in arch/riscv/kvm/vmid.c
> 2) Remove broken reference pattern from MAINTAINERS entry

Pulled, thanks.

Paolo
