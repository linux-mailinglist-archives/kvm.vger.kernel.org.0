Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E3054B5AC
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbiFNQPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 12:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244318AbiFNQOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 12:14:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954AA37A97;
        Tue, 14 Jun 2022 09:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=n2Lf1dv3/vYhoypTW+DaR3foJjocNhjGOTAkfna03bE=; b=a9+J3GZfwi0dYmj/giTWprkvjG
        snS4UAs9i2YAQxg93PGnfPa8OvT1b9TQU+GX0e76jjaPALvOPda9yJP8eo9qIWzk2eNREns1OvUwk
        ip2/1i01MvnkmSXtU1MAf9lMnoa2layUHhWSpp0JJB6tLC+7GqMi5/4sIz4INqsbH01g7mqLKVg45
        Iv/FtdjZ0AQ1wB16OImskbnzMhUWQuqBhDkOGFzCRGhAmzaczGzcqOTjbilJV1vJUUNCEpaN1GuXn
        RsVr75vu/Fo+ney5s0SXf3aqfC4n4M21MGZJWhMftScda7MHuhb+xlBdKHL+uWdhOEk57og9n1m/v
        gI7y0jRA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o19B2-007u2P-F9; Tue, 14 Jun 2022 16:14:03 +0000
Message-ID: <f29a340c-b960-7782-3c34-c75ff394d431@infradead.org>
Date:   Tue, 14 Jun 2022 09:13:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: linux-next: Tree for Jun 14 (arch/x86/kvm/svm/avic.c)
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        KVM list <kvm@vger.kernel.org>
References: <20220614161729.247d71f7@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220614161729.247d71f7@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/13/22 23:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20220610:
> 

on i386:

In file included from ../include/linux/bits.h:6:0,
                 from ../include/linux/kvm_types.h:21,
                 from ../arch/x86/kvm/svm/avic.c:17:
../arch/x86/kvm/svm/avic.c: In function ‘avic_check_apicv_inhibit_reasons’:
../include/vdso/bits.h:7:26: warning: left shift count >= width of type [-Wshift-count-overflow]
 #define BIT(nr)   (UL(1) << (nr))
                          ^
../arch/x86/kvm/svm/avic.c:911:6: note: in expansion of macro ‘BIT’
      BIT(APICV_INHIBIT_REASON_SEV      |
      ^~~


From commit 3743c2f02517
Author: Maxim Levitsky <mlevitsk@redhat.com>
Date:   Mon Jun 6 21:08:24 2022 +0300

    KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base


-- 
~Randy
