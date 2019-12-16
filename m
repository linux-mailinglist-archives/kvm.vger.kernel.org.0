Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672A3120215
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 11:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfLPKPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 05:15:18 -0500
Received: from foss.arm.com ([217.140.110.172]:48414 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfLPKPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 05:15:18 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 991761FB;
        Mon, 16 Dec 2019 02:15:17 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EF3D3F6CF;
        Mon, 16 Dec 2019 02:15:16 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 03/18] lib: Add WRITE_ONCE and READ_ONCE
 implementations in compiler.h
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com, Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
 <20191128180418.6938-4-alexandru.elisei@arm.com>
 <df974420-5853-245a-c616-eeb7a54dd35e@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <24557dd9-d7dd-11a2-02ec-e16c642b5618@arm.com>
Date:   Mon, 16 Dec 2019 10:15:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <df974420-5853-245a-c616-eeb7a54dd35e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 12/9/19 2:21 PM, Thomas Huth wrote:
> On 28/11/2019 19.04, Alexandru Elisei wrote:
>> Add the WRITE_ONCE and READ_ONCE macros which are used to prevent to
> Duplicated "prevent to" - please remove one.
>
>> prevent the compiler from optimizing a store or a load, respectively, into
>> something else.
> Could you please also add a note here in the commit message about the
> kernel version that you used as a base? ... the file seems to have
> changed quite a bit in the course of time, so I think it would be good
> if we know the right base later.
>
>  Thomas

Will implement both suggestions, thank you for taking a look.

Thanks,
Alex
