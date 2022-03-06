Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A5B4CE82E
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 02:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiCFByT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 20:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCFByS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 20:54:18 -0500
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7B173079
        for <kvm@vger.kernel.org>; Sat,  5 Mar 2022 17:53:27 -0800 (PST)
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay08.hostedemail.com (Postfix) with ESMTP id 47A6421106;
        Sun,  6 Mar 2022 01:53:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id 6C1EB6000B;
        Sun,  6 Mar 2022 01:53:23 +0000 (UTC)
Message-ID: <133c543af026f99f0cd148d4403cf426e8470666.camel@perches.com>
Subject: Re: [PATCH v2 2/6] KVM: Replace bare 'unsigned' with 'unsigned int'
From:   Joe Perches <joe@perches.com>
To:     Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 05 Mar 2022 17:53:24 -0800
In-Reply-To: <CAFJXJGHc3D3U+BOBW2BqSX-vhsXSCZ-=R2ydfMtVML02+C3MuQ@mail.gmail.com>
References: <20220305205528.463894-7-henryksloan@gmail.com>
         <20220306012804.117574-1-henryksloan@gmail.com>
         <c8e5a476d1e7902fb1444b42113316fc68b627d5.camel@perches.com>
         <CAFJXJGHc3D3U+BOBW2BqSX-vhsXSCZ-=R2ydfMtVML02+C3MuQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6C1EB6000B
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Stat-Signature: bn911fnywchixjbq847s3kdwapwqtsam
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/ohUxZXFbRhkSXApJJz7HE0ccBX4HvrHE=
X-HE-Tag: 1646531603-34971
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-03-05 at 20:44 -0500, Henry Sloan wrote:
> I agree the bool conversion should be a separate patch. Would it be proper
> to resubmit the whole patchset with a new, seventh patch containing the
> bool conversion? If I was to do so, should all of those patches be labelled
> v2, but without any changelogs since none of the present patches will have
> been changed?

Generally yes, but it depends on the upstream maintainer's preference.

Ideally:

o a 0/n patch cover letter could be used to describe the change/addition
o each proposed patch has a patch description above your Signed-off-by:



