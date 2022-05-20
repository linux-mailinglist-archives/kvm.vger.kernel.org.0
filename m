Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505DD52EC0D
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349165AbiETM2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 08:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236590AbiETM2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:28:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EC8C16498D
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 05:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653049720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Hx+KxtCI34mte4YhCUAYcxj2ePeixbDyvemaWLUfBuFGR6EtKrTJt0o9Pvho4J+QgA7zNj
        q1PlDq8l69ZSpZWi0qaZN8bxyySpZH9QKx9ovyAO5GKuKPdqgpkmLiL7CS+TfRSX+MBjjT
        vz9z7evtkmzclhHoB7t54ZO2WyBb4xQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-AwVlYtIgOtOBKL8hjsMw3A-1; Fri, 20 May 2022 08:28:35 -0400
X-MC-Unique: AwVlYtIgOtOBKL8hjsMw3A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A41B13831C51;
        Fri, 20 May 2022 12:28:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C2FC492C3B;
        Fri, 20 May 2022 12:28:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/16] Introduce Architectural LBR for vPMU
Date:   Fri, 20 May 2022 08:28:32 -0400
Message-Id: <20220520122832.3315325-1-pbonzini@redhat.com>
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


