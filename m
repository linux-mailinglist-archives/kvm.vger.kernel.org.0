Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834C477E78D
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 19:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345207AbjHPR2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 13:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345276AbjHPR2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 13:28:38 -0400
X-Greylist: delayed 362 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Aug 2023 10:28:37 PDT
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDEA26B5
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 10:28:37 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id C2FC64010B;
        Wed, 16 Aug 2023 17:22:29 +0000 (UTC)
Date:   Wed, 16 Aug 2023 22:22:29 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Roman Mamedov <rm+bko@romanrm.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: kvm: Windows Server 2003 VM fails to work on 6.1.44 (works fine
 on 6.1.43)
Message-ID: <20230816222229.1877d6c8@nvm>
In-Reply-To: <87cyzn5cln.fsf@redhat.com>
References: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
        <87o7j75g0g.fsf@redhat.com>
        <87il9f5eg1.fsf@redhat.com>
        <87cyzn5cln.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Aug 2023 15:41:08 +0200
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Sean's https://lore.kernel.org/all/20230811155255.250835-1-seanjc@google.com/
> (alteady in 'tip') can actually be related and I see it was already
> tagged for stable@. Can anyone check if it really helps?

Indeed, this patch appears to fix it. I built 6.1.46 with it added, and the
issue is no longer present. Thanks!

-- 
With respect,
Roman
