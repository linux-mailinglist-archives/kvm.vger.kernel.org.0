Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F94265E8
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 10:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhJHIa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 04:30:58 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:34665 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhJHIa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 04:30:57 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MkIAB-1n1oXt0bs1-00kjtT; Fri, 08 Oct 2021 10:29:00 +0200
Received: by mail-wr1-f52.google.com with SMTP id r18so27281932wrg.6;
        Fri, 08 Oct 2021 01:29:00 -0700 (PDT)
X-Gm-Message-State: AOAM533Y+2nbKM6SJgkqoDRu8UwCxIdncqlCHuI/0AmT11OcJ38kt8/u
        EYGODxaB51+iDNR22GENxxzX9xa7Q0rRT7609tI=
X-Google-Smtp-Source: ABdhPJyBXhX12PpUH/38oXcC7qr2BYBPWQ5taeWZl0TIvVnaFmovsl1ju5x37gj8x61HAzSl9KvyaqVJ+2IwzjjJtjY=
X-Received: by 2002:adf:a3da:: with SMTP id m26mr2249533wrb.336.1633681739740;
 Fri, 08 Oct 2021 01:28:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211008131649.01295541@canb.auug.org.au>
In-Reply-To: <20211008131649.01295541@canb.auug.org.au>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 8 Oct 2021 10:28:43 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2h=DS=-xKc059YQg=K400kRUHHpJ=xyDPRW40D3ZsaTQ@mail.gmail.com>
Message-ID: <CAK8P3a2h=DS=-xKc059YQg=K400kRUHHpJ=xyDPRW40D3ZsaTQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the kvm tree with the asm-generic tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Anup Patel <anup.patel@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:cO3gUc9t+xVLt/YFmZBBzbXujU8kFS4KLvTC3xr9KctFGUjmdlX
 uLgIppT/EbulXUlhANavFjfJyWl5Ypqf+XvvqqslpH497JiCNYrRTvGirWpbLSWk2MdkpZL
 qdMlPnolh5d1YE0kSFO4Tk6VpsM7Hzo5nKaV/bJWzloGWTRlLEMYwrGhp3Oa1RLO7t+ea5Y
 WPQViijWrH5UDhlA/AZNg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MqdWWM9NNSg=:1rqzRRiSLLV6wRpRhTbrQn
 TAMADRrVJPUvSszf4zzk+hyzrJAR72mvTXR7pL8M3twTWcxMqEtTKObGBt2jYSQrk8nvPmXfB
 DQi+/oriT1O+VXJcuCwFCDe/pPqHXS3XzKgPlpey+ufFWLLVObpa8iO4ne+jPnI1FShjrDHtc
 70AaQP+TugLbpQoNyKCMMyNzAb3pMQ54e/Cm+l1lN7gYlzLFOyyJqvwn3jL3mMJBaWYAFwqnF
 odJBXVtIMz2pneGllEuvW3NsWIb+svOx44QkP+i+3BE24aBM4GiriKtlrN7srTWeZsrvsNcq9
 8zdXXrqLgwp8+iCTkRLEpYZJ3DRTKNtL6OoAmzVgilChi4TvtU3AZIFOM7tJ/pX3BHvTBq2vf
 amVUJKd4VVAJ4wGFi22RAsV4TsMcEF8eKc1sCE8K1tIGcJqY2x27GwrAvJaEwNL4f1gcxXiDC
 aG0oIUz5eF9bVWX+XflwZuvXyOdUXYqcAuY7N9nArwpBsNqMbjwxz586Xt/jE91cbtcLAnRkb
 WBQd0n4sEh8rXKecxBbHgjLn7DDQP+/kABxA1nDsaU6pVFukUUOwy4rsmna6brl5nh1uOa5uQ
 RKKk1C0LaFQSt9aTeEEq11gllDfcw4WKBG5vsdf20ekpWd50hLIsdN1RAgUyWVNxmnUYOynn+
 QSh/R7MQjWOB3lsc8BKVGaDlThR4G6rC4II3860w4+PSlI6KMVGmUOLW5ptpYhFzH09NiiKAs
 5FgbJMzs2If2Czl3bwNygJq7kNqvbtOz7dX6P6+a/gmnGElS6lB1tQwRzu5Q40G+NkiPjm+6l
 FLRa4j9pUea/VsZQ3x76+POnWyFCbYvm1oylp1LSK4wwHmuONBRJAdIeW7flLNYXusZ/hV1at
 U8w6Xa5IBJfbJIPFxWjw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 8, 2021 at 4:17 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Today's linux-next merge of the kvm tree got a conflict in:
>
>   arch/riscv/Kconfig
>
> between commit:
>
>   b63dc8f2b02c ("firmware: include drivers/firmware/Kconfig unconditionally")
>
> from the asm-generic tree and commit:
>
>   99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
>
> from the kvm tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Looks good, thanks!

I'm planning to send the commit in the asm-generic tree to mainline
today, so it will then be a conflict against 5.15.

       Arnd
