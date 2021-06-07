Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B74A39E78F
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 21:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhFGTie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 15:38:34 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:13831 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhFGTid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 15:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1623094602; x=1654630602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3OIyzRHmDgMowmJ2Eo4aqFZIO2AdOEYwfOVmpKiyKgM=;
  b=V++z8u+8lJmIIgVQA/cQ+KBhwumXNIOBkj8PzFIGfHILLStH2iTAyjtL
   fH9mJ0QKWoOYtU4tPG6lGLGgXYz1FEukBhJ23ROQ/VC46/EhJsX9AdpSf
   x/ExZOKlPLplAhX3lEhlirLzHUtxhHRWCfbL9pJiPXcDL3gGaquzt5cuH
   o=;
X-IronPort-AV: E=Sophos;i="5.83,255,1616457600"; 
   d="scan'208";a="129662956"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 07 Jun 2021 19:36:35 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id AB033A2265;
        Mon,  7 Jun 2021 19:36:33 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.137) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 7 Jun 2021 19:36:29 +0000
Date:   Mon, 7 Jun 2021 21:36:25 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] Handle hypercall code overlay page in userspace
Message-ID: <20210607193624.GA7976@uc8bbc9586ea454.ant.amazon.com>
References: <cover.1621885749.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1621885749.git.sidcha@amazon.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D27UWB002.ant.amazon.com (10.43.161.167) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A reminder email to bring these up on your inboxes :). Would love
to hear your thoughts on them.

~ Sid.



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



