Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE019CABD
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 22:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388940AbgDBUEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 16:04:54 -0400
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:11041
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388781AbgDBUEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 16:04:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWC+9KfLlXc2EAOz3dBA5htJ46EoWLv86RWiahvsnAnUNtH2Gbw0vnVJPb+mto0ne2EdBzlxRqhlvjvLY2Dkzk9RGrf8GupMHbTNcPOqPYh17T+SDhNpBcs+YFPmjU7VPnZKeAIzdhJCsZjn9rbGEn8c6bknMHYYrqgp4yqfJ4UZVXivzUZeK5CoyzztPz9fyPZQEbuyv13U1AlWw+nubBTy+G6kT9/upv/y5GcqaIITvXQgFsekAndx0G4ZL5OM9Gwg6sRCa/tMqeIzfEtF/TVuyZErpLChmZ137hR5UOvW283T+aRvqvlr2TiM3LNMPSB94XhZeKHiNib8eV8L4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uc7IuOMoqgZ2h0POKQTHiFou0/ojWSjUtD0orWlqjRo=;
 b=k52DCN9lNaM+u3uzNACHG7sxfW5yEChdqHx8Opc8qY3P5LLvRtLhjSe1ghYCFn/UtdCnPTn26oqS7C0JjxY1GjHJtyAW7eG57nSyoCPKaRklX4SU0TJvJZS1t8yyIllaNFSCnyO5T4cPHHQwvk1NRYhrmC3WVAkHQAlm0wP9SMMz4s1f4nz9Q5i8vaFj/fy+PBfvVUH3aqi8grZHPLM1rKKNWCPQrdUR9JQKEfxVAIMONY4BFznUG2o/boPt6NMt1MBniPPjdL8AEzrcRRsOIr7rOfGGoZYaFlEAHdSB0qDit2zTi4OCuNofLZLg1i0TLCPxgvLQYfsDd2j6DLZHww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uc7IuOMoqgZ2h0POKQTHiFou0/ojWSjUtD0orWlqjRo=;
 b=Iq9uel0bXynGurVBxR54RaQy5UcoN79V5WFGcVtD28aMgPtYH5FF5hbIAXoLL5nmyCWzFFl5n6RLAlrWiVO5ZzujxncVSwwwJ29PraGq2Au1a91V+3+fxsxXart/4gFh9VIvKIkCpTVlutyJG/PpxAp3cOSkMHQYtx0z9nnJ1Z8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 2 Apr
 2020 20:04:51 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::60d9:da58:71b4:35f3%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 20:04:51 +0000
Cc:     brijesh.singh@amd.com, Ashish Kalra <Ashish.Kalra@amd.com>,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 01/14] KVM: SVM: Add KVM_SEV SEND_START command
To:     Venu Busireddy <venu.busireddy@oracle.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <3f90333959fd49bed184d45a761cc338424bf614.1585548051.git.ashish.kalra@amd.com>
 <20200402062726.GA647295@vbusired-dt>
 <89a586e4-8074-0d32-f384-a4597975d129@amd.com>
 <20200402163717.GA653926@vbusired-dt>
 <8b1b4874-11a8-1422-5ea1-ed665f41ab5c@amd.com>
 <20200402185706.GA655878@vbusired-dt>
 <6ced22f7-cbe5-a698-e650-7716566d4d8a@amd.com>
 <20200402194313.GA656773@vbusired-dt>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f715bf99-0158-4d5f-77f3-b27743db3c59@amd.com>
Date:   Thu, 2 Apr 2020 15:04:54 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200402194313.GA656773@vbusired-dt>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0401CA0008.namprd04.prod.outlook.com
 (2603:10b6:803:21::18) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN4PR0401CA0008.namprd04.prod.outlook.com (2603:10b6:803:21::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 20:04:49 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10259100-5399-48e9-eb50-08d7d7411a9e
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:|SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB457414ED96BB6D126A2943C2E5C60@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(52116002)(66946007)(66556008)(8676002)(5660300002)(7416002)(4326008)(6506007)(2906002)(66476007)(6916009)(6512007)(44832011)(8936002)(81156014)(6486002)(6666004)(36756003)(53546011)(956004)(81166006)(316002)(86362001)(2616005)(16526019)(478600001)(31686004)(186003)(26005)(31696002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elb1xbxps8B1hMTcwfwNW37SZJLBdQ55ToVKzkGKEMFnslHgJdh2NE2MlbQ3PnkUVp3FBbXfytKKGJRCFlr5a90A7O24Dq4HCFAfQ4XJkPnEElDtZ5e+LtLlWwcsHIZhFk4gOuv8NeTU/COXUa63L97LCLeBnDFlkWDjJOpaYiF5aDsx7TPBe7rTY/6tSdhjJOZmcrC/jEUBkpZxmZh/4sOd4qDnLwEKsax29SfSYhCGouB3wRyawlBLtPY3hU0T6UOq9/WHu8dRLPg6QZreSInU5oXYP/B+M6soztrh4Ij5IMhglhaWq648BzGgaypBK8droOamkyZY1COB9UWfdpYCNZgQENIJJTYaVk/D9g+gJUXUTt7RUKt0TbCcQd0EY+5rQqBZQiYyvd73otTyvAejXC6Vku0QEjh6BFALv/m3yPxlGfwalr8WBjgoqeHy
X-MS-Exchange-AntiSpam-MessageData: 9TaUEpHp6jC54GWRx/ZHtPWXK5xD2FuL3A+aprG/knP43ZJdwIHuAENB/HAY6tPNbSXIh7dbXjaGVEYMHwTXSYaGlfFUCvSTMgTDjCNqDFTcSQn17VdUu+HVeYflFiUheC/SIauE09xQMfARIYVxIQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10259100-5399-48e9-eb50-08d7d7411a9e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 20:04:51.7933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBFhGRuuFQGOFmm8WvEvB2J2W8E81ICEuMgPsZf+xJYYxZQyKFEofDk8g/vBlTly/E09xpI1byZLmVBuac18Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/2/20 2:43 PM, Venu Busireddy wrote:
> On 2020-04-02 14:17:26 -0500, Brijesh Singh wrote:
>> On 4/2/20 1:57 PM, Venu Busireddy wrote:
>> [snip]...
>>
>>>> The question is, how does a userspace know the session length ? One
>>>> method is you can precalculate a value based on your firmware version
>>>> and have userspace pass that, or another approach is set
>>>> params.session_len = 0 and query it from the FW. The FW spec allow to
>>>> query the length, please see the spec. In the qemu patches I choose
>>>> second approach. This is because session blob can change from one FW
>>>> version to another and I tried to avoid calculating or hardcoding the
>>>> length for a one version of the FW. You can certainly choose the first
>>>> method. We want to ensure that kernel interface works on the both cases.
>>> I like the fact that you have already implemented the functionality to
>>> facilitate the user space to obtain the session length from the firmware
>>> (by setting params.session_len to 0). However, I am trying to address
>>> the case where the user space sets the params.session_len to a size
>>> smaller than the size needed.
>>>
>>> Let me put it differently. Let us say that the session blob needs 128
>>> bytes, but the user space sets params.session_len to 16. That results
>>> in us allocating a buffer of 16 bytes, and set data->session_len to 16.
>>>
>>> What does the firmware do now?
>>>
>>> Does it copy 128 bytes into data->session_address, or, does it copy
>>> 16 bytes?
>>>
>>> If it copies 128 bytes, we most certainly will end up with a kernel crash.
>>>
>>> If it copies 16 bytes, then what does it set in data->session_len? 16,
>>> or 128? If 16, everything is good. If 128, we end up causing memory
>>> access violation for the user space.
>> My interpretation of the spec is, if user provided length is smaller
>> than the FW expected length then FW will reports an error with
>> data->session_len set to the expected length. In other words, it should
>> *not* copy anything into the session buffer in the event of failure.
> That is good, and expected behavior.
>
>> If FW is touching memory beyond what is specified in the session_len then
>> its FW bug and we can't do much from kernel.
> Agreed. But let us assume that the firmware is not touching memory that
> it is not supposed to.
>
>> Am I missing something ?
> I believe you are agreeing that if the session blob needs 128 bytes and
> user space sets params.session_len to 16, the firmware does not copy
> any data to data->session_address, and sets data->session_len to 128.
>
> Now, when we return, won't the user space try to access 128 bytes
> (params.session_len) of data in params.session_uaddr, and crash? Because,
> instead of returning an error that buffer is not large enough, we return
> the call successfully!


Ah, so the main issue is we should not be going to e_free on error. If
session_len is less than the expected len then FW will return an error.
In the case of an error we can skip copying the session_data into
userspace buffer but we still need to pass the session_len and policy
back to the userspace.

+	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
+
+	if (ret)
+		goto e_free;
+

If user space gets an error then it can decode it further to get
additional information (e.g buffer too small).

>
> That is why I was suggesting the following, which you seem to have
> missed.
>
>>> Perhaps, this can be dealt a little differently? Why not always call
>>> sev_issue_cmd(kvm, SEV_CMD_SEND_START, ...) with zeroed out data? Then,
>>> if the user space has set params.session_len to 0, we return with the
>>> needed params.session_len. Otherwise, we check if params.session_len is
>>> large enough, and if not, we return -EINVAL?
> Doesn't the above approach address all scenarios?
>
