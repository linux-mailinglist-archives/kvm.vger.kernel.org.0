Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4510B517435
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 18:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241610AbiEBQ1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 12:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbiEBQ1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 12:27:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 800BAAE48
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 09:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651508631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=I6cugVWbWdtrmAgZyBeBrJOwwELfgwKEybEAnB4v3xMLGHnL9FjeBHfp9pqTUVHhBv0i2E
        WloFEET+DcoOIiAGIRLdwQZ+9xuNqdGAGlexDe9KTKTTOIRgQdOl4TPAboQnfIHvflSFT+
        C88qxphWssuadq/4DBmI5AHUb7TG1RY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-6V7ilNgaP2WCZDPPac0TNA-1; Mon, 02 May 2022 12:23:46 -0400
X-MC-Unique: 6V7ilNgaP2WCZDPPac0TNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ABCF3C02B63;
        Mon,  2 May 2022 16:23:46 +0000 (UTC)
Received: from avogadro.lan (unknown [10.39.194.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6669B40D2820;
        Mon,  2 May 2022 16:23:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, joro@8bytes.org, wanpengli@tencent.com
Subject: Re: [PATCH 0/3] Include MKTME KeyID bits to MMU shadow_zero_check
Date:   Mon,  2 May 2022 18:22:07 +0200
Message-Id: <20220502162207.541095-1-pbonzini@redhat.com>
In-Reply-To: <cover.1650363789.git.kai.huang@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


