Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10247A31AC
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 19:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbjIPRcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Sep 2023 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbjIPRbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Sep 2023 13:31:35 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047A81BD
        for <kvm@vger.kernel.org>; Sat, 16 Sep 2023 10:31:29 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qhZ8a-0008Qm-MQ; Sat, 16 Sep 2023 19:31:20 +0200
Message-ID: <01f24b6a-7604-1243-d7e3-af16773cf2e9@maciej.szmigiero.name>
Date:   Sat, 16 Sep 2023 19:31:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 13/16] memory: Clarify mapping requirements for
 RamDiscardManager
Content-Language: en-US, pl-PL
To:     David Hildenbrand <david@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
References: <20230908142136.403541-1-david@redhat.com>
 <20230908142136.403541-14-david@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20230908142136.403541-14-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8.09.2023 16:21, David Hildenbrand wrote:
> We really only care about the RAM memory region not being mapped into
> an address space yet as long as we're still setting up the
> RamDiscardManager. Once mapped into an address space, memory notifiers
> would get notified about such a region and any attempts to modify the
> RamDiscardManager would be wrong.
> 
> While "mapped into an address space" is easy to check for RAM regions that
> are mapped directly (following the ->container links), it's harder to
> check when such regions are mapped indirectly via aliases. For now, we can
> only detect that a region is mapped through an alias (->mapped_via_alias),
> but we don't have a handle on these aliases to follow all their ->container
> links to test if they are eventually mapped into an address space.
> 
> So relax the assertion in memory_region_set_ram_discard_manager(),
> remove the check in memory_region_get_ram_discard_manager() and clarify
> the doc.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>


Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

