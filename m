Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1836FE5F7
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 23:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbjEJVKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 17:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjEJVKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 17:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC111FFB;
        Wed, 10 May 2023 14:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEE3763386;
        Wed, 10 May 2023 21:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B17C433EF;
        Wed, 10 May 2023 21:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683753019;
        bh=dzyGJaKwvNqOTh/VMeHXzsmtOTWoDkyOegIklNgVqPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=dTDfrgOQBN+ZBUaumAAYx+7uFhHLGqkVKx7ELNjcQgzRpuo4FmbmSkJRta4pXsiX+
         Rix2NBwvASRHxE2Fv0M13xifc2yHpp25eepJ7vll3WtX5OKtSaSDCtpXVfqU1O7x8p
         qcye4C6toyBDcIkUCzUiALfCoCLwjzkFu0sI6paXrowBBAmGHwE19aqatX+Gcv3W7k
         hcSnf3EeIH+7xRWgAEFT8dW2vA53+NfpDJsxKvUEqjQPRv2zqSFKI+C7ZSfRG5F+p9
         9bK8LIiz1fmcWrM26AgDLMzha770+LWeforCfh/z7ldT5p3ajnuJEG20Pj5OXFbpR/
         7Ed1OWHk0F99w==
Date:   Wed, 10 May 2023 16:10:17 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mike Pastore <mike@oobak.org>
Cc:     linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] PCI: Apply Intel NVMe quirk to Solidigm P44 Pro
Message-ID: <ZFwIObh1y6x9pMdw@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP_NaWYtA65-nMXj9qpU2j-VvonKt9JT34iOt15hR1iTi11Y9A@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023 at 09:23:20PM -0500, Mike Pastore wrote:
> On Tue, May 9, 2023 at 4:48 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > Applied with subject:
> >
> >   PCI: Delay after FLR of Solidigm P44 Pro NVMe
> >
> > to my virtualization branch for v6.5.
> 
> Thank you for testing! Should I submit a new version of the patch with
> this subject line?

I didn't actually *test* this; I assume you did, and I assume/hope I
didn't break anything when I moved PCI_VENDOR_ID_SOLIDIGM.

> > I also moved PCI_VENDOR_ID_SOLIDIGM to keep pci_ids.h sorted.
> 
> Ah, the base commit I'm referencing has some unsorted lines at the
> bottom, which threw me off. I can move it as well if I submit a new
> version. Thank you.

No, I made the tweaks in my local tree, and you don't need to do
anything more.  This on its way to v6.5.

You can check my work here to make sure I didn't break anything:

  https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git/commit/?h=virtualization&id=0ac448e0d29d

Bjorn
