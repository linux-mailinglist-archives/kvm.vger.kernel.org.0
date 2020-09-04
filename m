Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADC825DA8B
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgIDNxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 09:53:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57636 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730599AbgIDNxj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 09:53:39 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-V7ovNLOwN_KM-aREXwWD-g-1; Fri, 04 Sep 2020 09:53:36 -0400
X-MC-Unique: V7ovNLOwN_KM-aREXwWD-g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8C861017DC2;
        Fri,  4 Sep 2020 13:53:34 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-159.ams2.redhat.com [10.36.112.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 352A119C59;
        Fri,  4 Sep 2020 13:53:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 08/10] travis.yml: Add CI for macOS
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-9-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <a59faa32-cb72-754c-12c8-9aa81d98ba62@redhat.com>
Date:   Fri, 4 Sep 2020 15:53:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200901085056.33391-9-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/2020 10.50, Roman Bolshakov wrote:
> Build the tests on macOS and test TCG. HVF doesn't work in travis.
> 
> sieve tests pass but they might timeout in travis, they were left out
> because of that.
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  .travis.yml | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

