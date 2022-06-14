Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D8154B771
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbiFNRPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 13:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238015AbiFNRPs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 13:15:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33F042496B
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 10:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655226946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EDiAK2GiJU6eR+BGSbtydNAu/y+4B6YAP2tHj8SfNfo=;
        b=DxqSCAmhGKBRU3zt3eId0Y8ek7y7azeoOqqivGwp9YvApgh4W07WY42K4FN4TZoqPkrfIo
        1dE0nLjs42gROLqk5gLhQhtjeQOhimkw+18iyVVntzSp2DzUS/Z3b0MlrBiJe8XdjglJC2
        0OHaYn464VmFfSxikJF/L5vUBQq3tCg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-542-VoUwwPQOMbipyk1ETRr1RA-1; Tue, 14 Jun 2022 13:15:42 -0400
X-MC-Unique: VoUwwPQOMbipyk1ETRr1RA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3A483800C25;
        Tue, 14 Jun 2022 17:15:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BDC51415103;
        Tue, 14 Jun 2022 17:15:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH 0/6] KVM: Trivial cleanups
Date:   Tue, 14 Jun 2022 13:15:17 -0400
Message-Id: <20220614171516.1621156-1-pbonzini@redhat.com>
In-Reply-To: <20220605063417.308311-1-jiangshanlai@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued patches 2 and 4-6, thanks.

I also applied David's rewarded commit mesage for patch 6.

Paolo


