Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF7E6BBFC4
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 23:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCOW2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 18:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjCOW2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 18:28:33 -0400
X-Greylist: delayed 1498 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Mar 2023 15:28:27 PDT
Received: from rev.ng (rev.ng [5.9.113.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EE4234C3
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 15:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rev.ng;
        s=dkim; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cv/hyF/BM7Qs01Vk3pd9iphT2D4CHx286tP6lF+86Tw=; b=P9Fp2zH6p649rRZvSem0puV8pc
        wfqpLHAskVpro7OGM/j9iidjkzLEvv3Z2UdRH6y5I6rVN3sF8v/0aDYzSY9NYgk+xUHZIIwSsUuq2
        xB+zCzw6daLnKlBsJcJEfPpTWdVjrjuArIZ8MxaUuApNjQTsICcJ+2sQtSPj0uJj/JCg=;
Date:   Wed, 15 Mar 2023 23:01:39 +0100
From:   Alessandro Di Federico <ale@rev.ng>
To:     Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>
Cc:     qemu-devel@nongnu.org, Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6k=?= Lureau <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?B?Q8Op?= =?UTF-8?B?ZHJpYw==?= Le Goater 
        <clg@kaod.org>, Darren Kenny <darren.kenny@oracle.com>,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        Anton Johansson <anjo@rev.ng>,
        =?UTF-8?B?TmljY29s?= =?UTF-8?B?w7I=?= Izzo <nizzo@rev.ng>,
        Paolo Montesel <babush@rev.ng>
Subject: Re: [PATCH v2 30/32] contrib/gitdm: add revng to domain map
Message-ID: <20230315230139.507b8bb4@orange>
In-Reply-To: <20230315174331.2959-31-alex.bennee@linaro.org>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
        <20230315174331.2959-31-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Mar 2023 17:43:29 +0000
Alex Benn=C3=A9e <alex.bennee@linaro.org> wrote:

> +rev.ng          revng

Can we have "rev.ng Labs"?
I suggested this in my previous e-mail too, but maybe it slipped away.

--=20
Alessandro Di Federico
rev.ng Labs
