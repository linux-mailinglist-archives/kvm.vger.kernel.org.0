Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6536D5FAEA9
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 10:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJKIqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 04:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiJKIqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 04:46:47 -0400
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1075817C
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 01:46:46 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.1.149])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 678A92565A;
        Tue, 11 Oct 2022 07:28:20 +0000 (UTC)
Received: from kaod.org (37.59.142.101) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12; Tue, 11 Oct
 2022 09:28:18 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-101G00444200b5b-e075-49ba-b716-5c6790d0e890,
                    D76C732790D2D2C2DE3D1CB86A566AEA08299A57) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <496e0c8b-17fe-9c9b-fbb3-7abb9ba61db4@kaod.org>
Date:   Tue, 11 Oct 2022 09:28:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <frankja@linux.ibm.com>, <berrange@redhat.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-2-pmorel@linux.ibm.com>
 <166237756810.5995.16085197397341513582@t14-nrb>
 <c394823e-edd5-a722-486f-438e5fba2c9d@linux.ibm.com>
 <0d3fd34e-d060-c72e-ee19-e9054e06832a@kaod.org>
 <724d962a-c11b-c18d-f67f-9010eb2f32e2@linux.ibm.com>
 <dff1744f-3242-af11-6b4b-02037a7e2af5@linux.ibm.com>
 <3becce0a-1b7a-385a-4180-f68cf192595a@kaod.org>
 <e48d20de-11a4-9e2b-77a1-0a6014f7e0ea@linux.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <e48d20de-11a4-9e2b-77a1-0a6014f7e0ea@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG2EX2.mxp5.local (172.16.2.12) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: dfe08c96-21f1-44ad-8d43-b07fd2991925
X-Ovh-Tracer-Id: 1951184539371670288
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejhedguddukecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepkeetjedtleekjedvveffudfhteetleeifeegfeffuefghfefkeehffeufeeludejnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsggvrhhrrghnghgvsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvd
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/22 09:21, Pierre Morel wrote:
> 
> 
> On 9/28/22 18:28, Cédric Le Goater wrote:
>> On 9/28/22 18:16, Pierre Morel wrote:
>>> More thinking about this I will drop this patch for backward compatibility and in topology masks treat CPUs as being cores*threads
>>
>> yes. You never know, people might have set threads=2 in their
>> domain file (like me). You could give the user a warning though,
>> with warn_report().
> 
> More thinking, I come back to the first idea after Daniel comment and protect the change with a new machine type version.

yes. That would be another machine class attribute to set in the new machine,
may be 'max_threads' to compare with the user provided value.

C.

> 
> 
>>
>> Thanks,
>>
>> C.
>>
>>
>>>
> 

