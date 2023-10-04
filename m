Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D2D7B7749
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 07:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241298AbjJDFAV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 4 Oct 2023 01:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjJDFAU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 01:00:20 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83390A6;
        Tue,  3 Oct 2023 22:00:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4S0jDM5gY6z4xQT;
        Wed,  4 Oct 2023 16:00:03 +1100 (AEDT)
Date:   Wed, 04 Oct 2023 16:00:02 +1100
From:   Michael Ellerman <michael@ellerman.id.au>
To:     Jonathan Corbet <corbet@lwn.net>,
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
        =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
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
User-Agent: K-9 Mail for Android
In-Reply-To: <87cyxvelnn.fsf@meer.lwn.net>
References: <169052340516.4355.10339828466636149348@legolas.ozlabs.org> <20230826165737.2101199-1-costa.shul@redhat.com> <87cyxvelnn.fsf@meer.lwn.net>
Message-ID: <46705070-17B2-4BDA-9524-1BB2F7BDBACA@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On October 4, 2023 3:05:48 AM GMT+11:00, Jonathan Corbet <corbet@lwn.net> wrote:
>Costa Shulyupin <costa.shul@redhat.com> writes:
>
>> and fix all in-tree references.
>>
>> Architecture-specific documentation is being moved into Documentation/arch/
>> as a way of cleaning up the top-level documentation directory and making
>> the docs hierarchy more closely match the source hierarchy.
>>
>> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
>
>So this patch appears to have not been picked up, and to have received
>no comments.  I'll happily carry it in docs-next, but it would be nice
>to have an ack from the powerpc folks...?

I acked it a few months back, and said I assumed you were merging it:

https://lore.kernel.org/linuxppc-dev/87bkfwem93.fsf@mail.lhotse/

I don't mind who merges it, I figured you merging it would generate fewer conflicts, but I'm happy to take it if you think that would be better.

Anyway here's another:

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
