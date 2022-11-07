Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4A61FB22
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 18:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbiKGRWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 12:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiKGRVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 12:21:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6496B1DF2D
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 09:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667841652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O1uODv2NTtFh6nrlGSnkHycdHBAbqkNdNpxthhd40ck=;
        b=AkzUowkJNYwSSYxbmpK8xZ3j4jbgv0J8B6NjDyyWvFbZurusiCoaTcIeuhdg9SlVOaph3E
        Rlww2DmRO03S+dHHxRGoyGmJWzmd2Z/0tHJub5T7PAlxApsK/Yr/LErPFanMp1AAF5UYq7
        Uz1zG+CQBXXLW5ZoT931SuMM3XN2rJo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-NC8MfLbPPG-dLv78oABmfw-1; Mon, 07 Nov 2022 12:20:47 -0500
X-MC-Unique: NC8MfLbPPG-dLv78oABmfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74B1F85A5A6;
        Mon,  7 Nov 2022 17:20:46 +0000 (UTC)
Received: from localhost (unknown [10.39.193.202])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AC61C15BB5;
        Mon,  7 Nov 2022 17:20:46 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH v5 8/8] Documentation: document the ABI changes for
 KVM_CAP_ARM_MTE
In-Reply-To: <20221104011041.290951-9-pcc@google.com>
Organization: Red Hat GmbH
References: <20221104011041.290951-1-pcc@google.com>
 <20221104011041.290951-9-pcc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 07 Nov 2022 18:20:44 +0100
Message-ID: <87a6523clv.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03 2022, Peter Collingbourne <pcc@google.com> wrote:

> Document both the restriction on VM_MTE_ALLOWED mappings and
> the relaxation for shared mappings.
>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  Documentation/virt/kvm/api.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

