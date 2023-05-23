Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D47770D086
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbjEWBdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjEWBdw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:33:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649B58E;
        Mon, 22 May 2023 18:33:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0154662339;
        Tue, 23 May 2023 01:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A284C433EF;
        Tue, 23 May 2023 01:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684805630;
        bh=VLQAZ0ni90Kw6iE14tA7Ei4jvKZaqtf32yr37fGDBu4=;
        h=Date:From:To:Cc:Subject:From;
        b=psNKhCSf1o9RfAcrMtHIcPoveO8TCKajkd0vKDcMLyD6rQh5PC7oobvqhSyGR0gZ3
         0xXNkUft/oNmxPALM1nbNaL/j+5nr5G8P+gRm2bbAC475hPgpX0Q5V8zyvOekpvKkJ
         rN2b69IWsBAKlzrTFVUt8hTcvd26vOYrM2llEnX0egB/Xi+rAxA6SdgxGTYb5+hwS7
         IgmnpL90KU8te4ur38R0wFHWWtOqAs3Nj9+5JvFwemYEBrvoscmoB6qRtVMB7MTasb
         Yf0MwlpFaG3TLe6o11vHtW22acjcBZET8JoojGGZuIk+qXUnMgbdXCn+nZKEcrA0Qx
         URdn/s/tTGpxA==
Date:   Mon, 22 May 2023 19:34:41 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 0/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
Message-ID: <cover.1684805398.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

This small series aims to replace a one-element array with a
flexible-array member in struct vfio_ccw_parent.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/160
Link: https://github.com/KSPP/linux/issues/297
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]

Gustavo A. R. Silva (2):
  vfio/ccw: Replace one-element array with flexible-array member
  vfio/ccw: Use struct_size() helper

 drivers/s390/cio/vfio_ccw_drv.c     | 2 +-
 drivers/s390/cio/vfio_ccw_private.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1

