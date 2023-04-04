Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4BB6D601A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbjDDMU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbjDDMTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:19:34 -0400
Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD83640FB
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:17:06 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.188])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 1E53022056;
        Tue,  4 Apr 2023 12:17:03 +0000 (UTC)
Received: from kaod.org (37.59.142.97) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 14:17:02 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-97G00271947050-032d-42f3-bbac-fe0ddad42753,
                    85507D0075A56E5AD4EA03BF56E5282CC2D8C3A6) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <c24550f7-4468-a56e-17b0-642df650700c@kaod.org>
Date:   Tue, 4 Apr 2023 14:17:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v19 14/21] tests/avocado: s390x cpu topology core
Content-Language: en-US
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
To:     Pierre Morel <pmorel@linux.ibm.com>, <qemu-s390x@nongnu.org>
CC:     <qemu-devel@nongnu.org>, <borntraeger@de.ibm.com>,
        <pasic@linux.ibm.com>, <richard.henderson@linaro.org>,
        <david@redhat.com>, <thuth@redhat.com>, <cohuck@redhat.com>,
        <mst@redhat.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <ehabkost@redhat.com>, <marcel.apfelbaum@gmail.com>,
        <eblake@redhat.com>, <armbru@redhat.com>, <seiden@linux.ibm.com>,
        <nrb@linux.ibm.com>, <nsg@linux.ibm.com>, <frankja@linux.ibm.com>,
        <berrange@redhat.com>
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-15-pmorel@linux.ibm.com>
 <2b678e7d-488d-0072-2b27-cd54a43a77b2@kaod.org>
In-Reply-To: <2b678e7d-488d-0072-2b27-cd54a43a77b2@kaod.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.97]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 14b8fda1-0778-48eb-85ca-62282ac2068c
X-Ovh-Tracer-Id: 1530942398634429395
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeiledghedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffhvfevfhgjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeegveegudfffeeigfdvteeukeefleetgeekgfefudekuedvjeduleeftdeihfdtffenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddrleejpdekvddrieegrddvhedtrddujedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehpmhhorhgvlheslhhinhhugidrihgsmhdrtghomhdpnhhsgheslhhinhhugidrihgsmhdrtghomhdpnhhrsgeslhhinhhugidrihgsmhdrtghomhdpshgvihguvghnsehlihhnuhigrdhisghmrdgtohhmpdgrrhhmsghruhesrhgvughhrghtrdgtohhmpdgvsghlrghkvgesrhgvughhrghtrdgtohhmpdhmrghrtggvlhdrrghpfhgvlhgsrghumhesghhmrghilhdrtghomhdpvghhrggskhhoshhtsehrvgguhhgrthdrtghomhdpkhhvmhesvhhgvg
 hrrdhkvghrnhgvlhdrohhrghdpfhhrrghnkhhjrgeslhhinhhugidrihgsmhdrtghomhdpphgsohhniihinhhisehrvgguhhgrthdrtghomhdptghohhhutghksehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdgurghvihgusehrvgguhhgrthdrtghomhdprhhitghhrghrugdrhhgvnhguvghrshhonheslhhinhgrrhhordhorhhgpdhprghsihgtsehlihhnuhigrdhisghmrdgtohhmpdgsohhrnhhtrhgrvghgvghrseguvgdrihgsmhdrtghomhdpqhgvmhhuqdguvghvvghlsehnohhnghhnuhdrohhrghdpqhgvmhhuqdhsfeeltdigsehnohhnghhnuhdrohhrghdpmhhsthesrhgvughhrghtrdgtohhmpdgsvghrrhgrnhhgvgesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-1.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/23 11:21, Cédric Le Goater wrote:
> On 4/3/23 18:28, Pierre Morel wrote:
>> Introduction of the s390x cpu topology core functions and
>> basic tests.
>>
>> We test the corelation between the command line and
>> the QMP results in query-cpus-fast for various CPU topology.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> 
> I gave the tests a run on a z LPAR. Nice job !

I forgot to add some timing output :

$ build/tests/venv/bin/avocado --show=app run   build/tests/avocado/s390_topology.py
  (01/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_single: PASS (4.78 s)
  (02/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_default: PASS (3.90 s)
  (03/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_move: PASS (3.82 s)
  (04/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_hotplug: PASS (3.84 s)
  (05/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_hotplug_full: PASS (3.94 s)
  (06/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_polarisation: PASS (4.59 s)
  (07/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_entitlement: PASS (4.65 s)
  (08/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_dedicated: PASS (4.65 s)
  (09/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_socket_full: PASS (4.25 s)
  (10/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_dedicated_error: PASS (4.46 s)
  (11/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_move_error: PASS (4.22 s)
  (12/12) build/tests/avocado/s390_topology.py:S390CPUTopology.test_query_polarization: PASS (4.63 s)


C.
