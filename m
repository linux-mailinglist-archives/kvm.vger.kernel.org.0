Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA01C4CE81F
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 02:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiCFBil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 20:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiCFBik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 20:38:40 -0500
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE4613DEE
        for <kvm@vger.kernel.org>; Sat,  5 Mar 2022 17:37:49 -0800 (PST)
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id C5A8580559;
        Sun,  6 Mar 2022 01:37:48 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id EF8B12002F;
        Sun,  6 Mar 2022 01:37:27 +0000 (UTC)
Message-ID: <c8e5a476d1e7902fb1444b42113316fc68b627d5.camel@perches.com>
Subject: Re: [PATCH v2 2/6] KVM: Replace bare 'unsigned' with 'unsigned int'
From:   Joe Perches <joe@perches.com>
To:     Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 05 Mar 2022 17:37:41 -0800
In-Reply-To: <20220306012804.117574-1-henryksloan@gmail.com>
References: <20220305205528.463894-7-henryksloan@gmail.com>
         <20220306012804.117574-1-henryksloan@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wfs7ptb66dodzhbxoox6c5acg71j38p6
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: EF8B12002F
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19h48FEYiSeDhfY5EbP/ccQe6i3Jc32m24=
X-HE-Tag: 1646530647-784904
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-03-05 at 20:28 -0500, Henry Sloan wrote:
> Signed-off-by: Henry Sloan <henryksloan@gmail.com>

Now the subject/patch description doesn't agree with the patch
so a different subject line needs to be used.

Perhaps the bool conversion should be a separate patch.

Also, this should have a change log below the --- like

> ---

v2: Use bool instead of unsigned int in coalesced_mmio.c

so people can know what has been changed between the original
submission and this V2 patch.

>  virt/kvm/coalesced_mmio.c | 23 ++++++++---------------


