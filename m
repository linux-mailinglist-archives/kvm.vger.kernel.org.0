Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6043728799
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 21:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbjFHTHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 15:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjFHTHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 15:07:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3478B2D40;
        Thu,  8 Jun 2023 12:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5A1A64F74;
        Thu,  8 Jun 2023 19:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AFDC433EF;
        Thu,  8 Jun 2023 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686251252;
        bh=GCMwx5k3Bt73ybwU+xYV6fYC/0AQ7aBIYHCUpkvNKfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=IMVbHFLxBjjj08+tTY4mqBYXPu+yPkr26OZEBnmqwftRD4Q1SIAVbxtVB+RaEhaTB
         9YNpxhOb06DUNpsGWpqlO8z9M/UoGEk2AM7sufDW3RJNemcOsnAqYtglNCuAJpE+kf
         JUNbc9ZTxw7AcQ/hSPwWfQdyFV4yp8l+IAq+TPrnPI702kcblJyStDWHqfH3yQj13S
         t0Qutj14xL88vuhjZ7Z7pf9c2BxwZj+zB62b8uEzHzrF0cwWx7KsTwLNS7kF2x5DgT
         9sI7zqmisychBq+ZtaxoiQBolhnEvyYOtA7a5hsVEwn9EOwYNv2+9Uz/yX7pGykML/
         Wog9TxmEmNR5g==
Date:   Thu, 8 Jun 2023 14:07:30 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <15330273260@189.cn>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        YiPeng Chai <YiPeng.Chai@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Li Yi <liyi@loongson.cn>,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        nouveau@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        loongson-kernel@lists.loongnix.cn, amd-gfx@lists.freedesktop.org,
        linux-pci@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v3 1/4] PCI/VGA: tidy up the code and comment
 format
Message-ID: <20230608190730.GA1209607@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608114322.604887-2-15330273260@189.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capitalize subject to match ("Tidy ...")

On Thu, Jun 08, 2023 at 07:43:19PM +0800, Sui Jingfeng wrote:
> From: Sui Jingfeng <suijingfeng@loongson.cn>
> 
> This patch replaces the leading space with a tab and removes the double
> blank line, no functional change.

Can you move this to the end of the series?  The functional changes
are more likely to be backported, and I think the backport may be a
little easier without the cleanup in the middle.

>  	/* we could in theory hand out locks on IO and mem
> -	 * separately to userspace but it can cause deadlocks */
> +	 * separately to userspace but it can cause deadlocks
> +	 */

Since you're touching this anyway, can you update it to the
conventional multi-line comment style:

  /*
   * We could in theory ...
   */

And capitalize "We", add a period at end, and rewrap to fill 78
columns or so?  Same for other comments below.

> +++ b/include/linux/vgaarb.h
> @@ -23,9 +23,7 @@
>   * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>   * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>   * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> - * DEALINGS
> - * IN THE SOFTWARE.
> - *
> + * DEALINGS IN THE SOFTWARE.
>   */

Can you make a separate patch to replace this entire copyright notice
with the appropriate SPDX-License-Identifier header?
Documentation/process/license-rules.rst has details.

Bjorn
