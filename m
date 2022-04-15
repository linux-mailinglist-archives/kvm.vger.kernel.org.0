Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF0B502640
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 09:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351124AbiDOHfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 03:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiDOHfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 03:35:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C10A0BE5
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 00:32:53 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8292E68B05; Fri, 15 Apr 2022 09:32:50 +0200 (CEST)
Date:   Fri, 15 Apr 2022 09:32:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 06/10] vfio: Remove vfio_external_group_match_file()
Message-ID: <20220415073250.GD24824@lst.de>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com> <6-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
