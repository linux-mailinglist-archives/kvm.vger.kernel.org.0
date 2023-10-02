Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E397B595E
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 19:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbjJBRId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 13:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjJBRIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 13:08:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901B4AB;
        Mon,  2 Oct 2023 10:08:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51544C433C8;
        Mon,  2 Oct 2023 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696266509;
        bh=QhZMAI126QClwacmWOKLD4jWk8FlpCqWOmI7dE0bK6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PvA06LhhNHDC6Y/ei2TPiBij5XUvK/9fFeEYW1KOBl7vetU1KwPB53gc9RY5Z7DGY
         gLsUVLeCApbij7oTvfncE7qxjWGct0Ivdvu0DU5hW9o2UWf0aeoxqaFmsCPGl0yQ7/
         36nc1CoCnnJ67wOJYDidtR+nkoTmOjFaC0r0HGToLN5V8XJ6+IvcA85JxNnFaW6YEr
         b4UJjH1RKtmTelaX+qPbjqK/QgSrTlP0R2GjJEVLew8nUKzMonkYt43ibjtDnZk1e4
         nmUF6pbvVF+tnbT1vReW8hykp5M8cgLPYmIF3v5jWp29hM04M1M28wN4S8PpsB/bLz
         Tabp0RhhFeIoA==
Date:   Mon, 2 Oct 2023 19:08:24 +0200
From:   Simon Horman <horms@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-scsi: Spelling s/preceeding/preceding/g
Message-ID: <20231002170824.GB92317@kernel.org>
References: <b57b882675809f1f9dacbf42cf6b920b2bea9cba.1695903476.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b57b882675809f1f9dacbf42cf6b920b2bea9cba.1695903476.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023 at 02:18:33PM +0200, Geert Uytterhoeven wrote:
> Fix a misspelling of "preceding".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Simon Horman <horms@kernel.org>

