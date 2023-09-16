Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A357A31B9
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 19:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbjIPRx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Sep 2023 13:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjIPRxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Sep 2023 13:53:09 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320A618D
        for <kvm@vger.kernel.org>; Sat, 16 Sep 2023 10:53:04 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qhZTS-00007z-N5; Sat, 16 Sep 2023 19:52:54 +0200
Message-ID: <2684efde-4d37-7320-e875-896e7b2727ee@maciej.szmigiero.name>
Date:   Sat, 16 Sep 2023 19:52:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 09/16] memory-device,vhost: Support memory devices that
 dynamically consume memslots
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
 <20230908142136.403541-10-david@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20230908142136.403541-10-david@redhat.com>
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
> We want to support memory devices that have a dynamically managed memory
> region container as device memory region. This device memory region maps
> multiple RAM memory subregions (e.g., aliases to the same RAM memory
> region), whereby these subregions can be (un)mapped on demand.
> 
> Each RAM subregion will consume a memslot in KVM and vhost, resulting in
> such a new device consuming memslots dynamically, and initially usually
> 0. We already track the number of used vs. required memslots for all
> memslots. From that, we can derive the number of reserved memslots that
> must not be used otherwise.
> 
> The target use case is virtio-mem and the hyper-v balloon, which will
> dynamically map aliases to RAM memory region into their device memory
> region container.
> 
> Properly document what's supported and what's not and extend the vhost
> memslot check accordingly.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thanks,
Maciej

