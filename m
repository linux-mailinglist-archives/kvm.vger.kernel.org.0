Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BE13AE9F2
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFUNZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 09:25:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229940AbhFUNZ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 09:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624281823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qKTBWS9aM3lo8TeiZQKJPhlfDImOzs5nrtJT2zCdYn4=;
        b=Oj0WrtBGJz8XY+dvEeAbDYmf57WNSuO2Sh4LBd00WMkLSq5onmKE+wx2/98lghkI9Rtxw0
        Mj4pIFCCI/sHu9azYNLfL5vtJo9LYNb1KLY8aTJDR+GmrDo1DTANnklbZHWJIr0b2i1VIb
        jC3e2ewdQeOL0+kggS1s0R+cB2AYUqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-TT26H9jpPMCzV6-ntBpDTw-1; Mon, 21 Jun 2021 09:23:40 -0400
X-MC-Unique: TT26H9jpPMCzV6-ntBpDTw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF99919057B1
        for <kvm@vger.kernel.org>; Mon, 21 Jun 2021 13:23:39 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FBA55D9CA;
        Mon, 21 Jun 2021 13:23:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] README.md: remove duplicate "to adhere"
Date:   Mon, 21 Jun 2021 09:23:38 -0400
Message-Id: <162428181337.157080.6841714409494849748.b4-ty@redhat.com>
In-Reply-To: <20210614100151.123622-1-cohuck@redhat.com>
References: <20210614100151.123622-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Jun 2021 12:01:51 +0200, Cornelia Huck wrote:
> 


Applied, thanks!

[1/1] README.md: remove duplicate "to adhere"
      commit: e6645b42a8a6c587500a6fbd784eb6ce6186a96e

Best regards,
-- 
Paolo Bonzini <pbonzini@redhat.com>

