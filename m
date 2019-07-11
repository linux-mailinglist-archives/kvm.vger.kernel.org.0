Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7BE655B0
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbfGKLcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 07:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbfGKLcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 07:32:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2A9D3082132;
        Thu, 11 Jul 2019 11:32:05 +0000 (UTC)
Received: from redhat.com (ovpn-117-151.ams2.redhat.com [10.36.117.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A3A9194B3;
        Thu, 11 Jul 2019 11:32:05 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PULL 00/19] Migration patches
In-Reply-To: <c2bfa537-8a5a-86a1-495c-a6c1d0f85dc5@redhat.com> (Paolo
        Bonzini's message of "Thu, 11 Jul 2019 13:19:44 +0200")
References: <20190711104412.31233-1-quintela@redhat.com>
        <c2bfa537-8a5a-86a1-495c-a6c1d0f85dc5@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Thu, 11 Jul 2019 13:32:02 +0200
Message-ID: <87ftncvmbx.fsf@trasno.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 11 Jul 2019 11:32:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 11/07/19 12:43, Juan Quintela wrote:
>> The following changes since commit 6df2cdf44a82426f7a59dcb03f0dd2181ed7fdfa:
>> 
>>   Update version for v4.1.0-rc0 release (2019-07-09 17:21:53 +0100)
>> 
>> are available in the Git repository at:
>> 
>>   https://github.com/juanquintela/qemu.git tags/migration-pull-request
>> 
>> for you to fetch changes up to 0b47e79b3d04f500b6f3490628905ec5884133df:
>> 
>>   migration: allow private destination ram with x-ignore-shared
>> (2019-07-11 12:30:40 +0200)
>
> Aren't we in hard freeze already?

They were sent bedfore the hard freeze, no?

Later, Juan.
