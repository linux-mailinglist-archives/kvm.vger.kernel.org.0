Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD137B80EF
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242683AbjJDNbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 09:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242594AbjJDNbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 09:31:52 -0400
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B111A1;
        Wed,  4 Oct 2023 06:31:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::646])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 1252D381;
        Wed,  4 Oct 2023 13:31:47 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 1252D381
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1696426307; bh=sC0LHUI2i/VOkBSihVVbnuIN3LRhiyHfuQI+/ge6LnQ=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=gPerOzCb2TxaxqtLNVmpTmHrfVXfZPgs4plx0KBo4VM5iu9HsCU/GD+XeDa1ZwifI
         cMK/+tF5afJWcVsp30wR/qQ4S+xX4JUdwBZEHXTX+bTSAmZndhyaEYGuqTt6NKd1u/
         gLDhgdTdcUToRJLrwQipPLu3/zmDx3FwRYpbVhA4/LGnAM45fkjbmJTTope5LetHfj
         EbBIU+VJMyITt9JR9pw5Fl+JgY1D8p31zWpzocL4TyyHK1REr2cb6yKKRsOXkWq1AH
         u3P4l6AiXH4xZpcFcyMArEqQP4U6aHLkUPXrWfAetx/VQ4AAcuQt0hzDfyFsAUlS+w
         bgsKJhbxbWONQ==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Michael Ellerman <michael@ellerman.id.au>,
        Costa Shulyupin <costa.shul@redhat.com>,
        Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Heiko Carstens <hca@linux.ibm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Benjamin Gray <bgray@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Rohan McLure <rmclure@linux.ibm.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Laurent Dufour <laurent.dufour@fr.ibm.com>,
        Nathan Lynch <nathanl@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-scsi@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] docs: move powerpc under arch
In-Reply-To: <46705070-17B2-4BDA-9524-1BB2F7BDBACA@ellerman.id.au>
References: <169052340516.4355.10339828466636149348@legolas.ozlabs.org>
 <20230826165737.2101199-1-costa.shul@redhat.com>
 <87cyxvelnn.fsf@meer.lwn.net>
 <46705070-17B2-4BDA-9524-1BB2F7BDBACA@ellerman.id.au>
Date:   Wed, 04 Oct 2023 07:31:46 -0600
Message-ID: <878r8i4ipp.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On October 4, 2023 3:05:48 AM GMT+11:00, Jonathan Corbet <corbet@lwn.net> wrote:
>>Costa Shulyupin <costa.shul@redhat.com> writes:
>>
>>> and fix all in-tree references.
>>>
>>> Architecture-specific documentation is being moved into Documentation/arch/
>>> as a way of cleaning up the top-level documentation directory and making
>>> the docs hierarchy more closely match the source hierarchy.
>>>
>>> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
>>
>>So this patch appears to have not been picked up, and to have received
>>no comments.  I'll happily carry it in docs-next, but it would be nice
>>to have an ack from the powerpc folks...?
>
> I acked it a few months back, and said I assumed you were merging it:
>
> https://lore.kernel.org/linuxppc-dev/87bkfwem93.fsf@mail.lhotse/
>
> I don't mind who merges it, I figured you merging it would generate fewer conflicts, but I'm happy to take it if you think that would be better.
>
> Anyway here's another:
>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

OK, sorry, somehow I missed that.  I'll apply it shortly.

Thanks,

jon
