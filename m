Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349662FF88A
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 00:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbhAUXPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 18:15:44 -0500
Received: from mail-eopbgr760079.outbound.protection.outlook.com ([40.107.76.79]:2695
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbhAUXNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 18:13:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4lsQ/UhUjOhdcf5wC22fQQPWJMMySa8A3LN3JoB/W6VLE+DIBDyfzrm7EkqU2G8ySsSBzMO9lpXbJtN+Blnx7tkL4zUF+lE4PaR+YBP59L2Osc2g8FeYHVrP99kbDD4aGtrFS2mh8Knlqip/gFa/s0vXqjrzRSWA2mNuRwTx2Cw2sUtijl24qnTPtP53YPR5r0eJ/UDDaeNejfj6kCvl1vbrb8EEkK+R8XbaDVx9cKe0yWw2L8K3jNVz7UKMWlOYMKUBk+kjroMUEQm7R96i3v3y583A6k5sAAskZLFqRSGxM9Utgth1K07XYrNhEHHXrxBoVdutfyczLuAFNKp0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRL+bWJIrTrWSrEYx1+Z2WnEMk8WsuvuMDKRoMfxr2k=;
 b=MPdBgWZOE/1rh0fqlM+yCe7ZvaryxsxvFKiKprJvK70q4A4NxqpKlwuXBd6+3qS+VIU/6a1br7bovoa4eUd1f3IwHhodX6JjzyZU8qKJ6T2d4IYca+SG7ef3fm9E1K+Mb8Q9+rgEWdsG/6SoTyEOYz7n3zhFRErItEWOCHZItuEh9YR60xAQTezxGOFwm2HOY+TsrjfFdSVFjl2iG1cJuLaxtRa9OfcH9SZ0z/8WbbbJLJsOOFtN+L6Bk2cPDiu29x34+BZ8AAWYVUKkwohLqmHS3KWFmYlDw/qPRYWalZyAaB4XcUmrWy2IfQQ6GUzOqLdYzCLAWcYAI0pRCQI0zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRL+bWJIrTrWSrEYx1+Z2WnEMk8WsuvuMDKRoMfxr2k=;
 b=ryLevIEdsa22F/Q6QUWObXT6V9dLrTqUgK2gwhW6PZJw+jnSLShvtlNUxNKQyay55++B+/S97rKedxvCDnsfxoVG9wd4s9QS2nlN81UUwNlfMppNViNLzDiw64vvhCyX4Q8dHbo0/K0JMPudpOB0MJUTWJYaaJIREGy9x6cQca4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4942.namprd12.prod.outlook.com (2603:10b6:5:1be::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 21 Jan 2021 23:12:48 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 23:12:47 +0000
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
To:     Tejun Heo <tj@kernel.org>
Cc:     Vipin Sharma <vipinsh@google.com>, brijesh.singh@amd.com,
        jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com,
        seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org> <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org> <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org> <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
Date:   Thu, 21 Jan 2021 17:12:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0235.namprd13.prod.outlook.com
 (2603:10b6:806:25::30) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0235.namprd13.prod.outlook.com (2603:10b6:806:25::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.9 via Frontend Transport; Thu, 21 Jan 2021 23:12:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b057396-ffee-404b-aede-08d8be6210f8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4942F90ACA870417F8E9964EECA10@DM6PR12MB4942.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h93QdaGqB9JjWZfp5cQMPB5PvBGqD7bXc10einxEe9jBbLROodp2uzmc/8X701FoPDX7aBRQXEEHASYYSugC0fDjihTgNsAqhCb8Li1UCbsY4wn+N0H9Pu+4pXcWYKNzc1sPEn0Hoixg+e85vMqFyxnKiyd0OlEbZQuhvbH+ajcJaOcqodJ+rbZ+1dxtR+kNVNZ4UKEuE2mkCQCqVik4PaYoD+DtiDOEPLXUixc/RYszCqeF/vBM850+BTb1zZ/2zWUBYRCL3V9F6h+6YcWHEDbaWGDuAKnJj9z2koIjP5fb6akughHRq1g0xqFrOpk4L/bSsHQ+tQPx5pGHusAf4gdA+6WjbYdnGsrtjziSs1f6bZ4nH/TZIC0vWnUpqOgzx2hlVDYL3gisR1ROlVAKTsiUAgC/CsIRpeWbMFgLQNJHVwEiNUe8KZjgywHBOxUGlMPank4kBy+uuLDG125vUB1phlwaVdFZMZqJX+QiOjo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(83380400001)(66946007)(2616005)(2906002)(52116002)(26005)(6512007)(31686004)(316002)(6506007)(8676002)(6916009)(36756003)(5660300002)(16526019)(66556008)(956004)(8936002)(31696002)(6486002)(53546011)(86362001)(66476007)(478600001)(7416002)(186003)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VEpBUko2a3RTQnNTUDZXamMwOEdEaG83dUpSK1NqeTY3YmhlTHRiZHBIc2dG?=
 =?utf-8?B?SEF1UWlXMXA5dkJnaWd6R05YRi94REpjd0ppdTY3WDRCeGwzMHVpV0M3aCty?=
 =?utf-8?B?VDFoUXIvcDA2UzE4RU9FTk00Z0g2WkVncWJ6S1N0M2sxdjdnZjQ0SzFteVBT?=
 =?utf-8?B?SVd1akpmZXhQK3Y4N1pCdmtBTW5jcS9ROG96OUx1TCtYVU0wRW9WUE03c29p?=
 =?utf-8?B?dFpIRTQ1QXEydFIyVzlHTmVSSWZWNmU1dEtTMXprdXNCRG5VL2dDdkFlaStn?=
 =?utf-8?B?cXJ4RjFKdmtZaVhyVGpFOFZLR3BjVG5jeTFERzlFUk9yUkcvaVhRaHgrVC9w?=
 =?utf-8?B?STY2SjRQUlgvUitXQ3RJcHpiOEFwUkFQNzBNY2FEYTJ0QTdZVSt4Q2pqbWVi?=
 =?utf-8?B?SHozbWJUYXUzcjM1MWIwODNDeE1IU2phWXRqMEZaS1Zpb3BHQjVqUXkxUWc3?=
 =?utf-8?B?RjY5aVpkY1kwZ0hJQnNkOFBack11MEE0RkV2SGtsK0c2ekJ6QWNHMmprcWQ4?=
 =?utf-8?B?eGZzS0FCZGhPRjB5MzZ6K1J1RlJxOGU3bEpRdnV6T09ZamJ2MGFlSXI2Sm11?=
 =?utf-8?B?QWY1bnVFWFQrTEFiMS85dm84UHFTdXNSdkNTeTZVUEtQTnVwbFVYaS9PWFdq?=
 =?utf-8?B?MjdyZ3I5UGhlV2ptQkRrYjdJbDdzMzQrY2tvK0RKRjZGaEsvZEw3TUZSb1RE?=
 =?utf-8?B?Y0M3UEtwRTJtNDBQcys0d3pOQUR3QWpxZG1wRURXSkQwZExOeER6eDZLd3Vp?=
 =?utf-8?B?NXR5R21ybXgveDlMTlZhMWxDYlVRckJhSmhyZ0VDRkdIYkUwLzFjMXJ4d04w?=
 =?utf-8?B?Nmh5enFidEhQakltWFM1WnQ3LzJpb0Faek4yTzEyV2RNREpaRDhyalUyT3Ev?=
 =?utf-8?B?QWt1cUpPcWpmRzF0Y0hYR2NOeVduVFdzVnM2QkJyc2ozMXNqbGF3VXREaXVJ?=
 =?utf-8?B?cjlKN0hLMzBYZDdSQ3I4RFZ4dHY4Vld4ckNHNy9LWGdqM3N4ZWlTcUVoZlFV?=
 =?utf-8?B?L1dvVncxcFpad21qYjVDU1lBdkZtUHQrdzY4WHBGNURjYXJmL1dpOWRWME1I?=
 =?utf-8?B?akpYN0l2V0tNUC96Ym5iMDlxU3NBQnN1TXhYaFRneTR0ZGtTQU83ZmowMmtm?=
 =?utf-8?B?Ymk3OFJNWE9zbjkzM2hCREphWm9EaWlsb1NRNGpwWXhsR0UzcjFrd0t1VjVY?=
 =?utf-8?B?ZmI4cm13Q0g0eU9VNmJmcGZqUXI4eWJUQXpDVUVSOE8zZlJyVTdZUXpBamFH?=
 =?utf-8?B?TGhPQmNWMXVVVXNILzEwR0NMYmxpbUowczAvekQxV2FLdVVzc3JVaHBJVzh3?=
 =?utf-8?Q?X2YEltePOyu06/+OVlRpXT8RMLpBmDawgE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b057396-ffee-404b-aede-08d8be6210f8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 23:12:47.7828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNoK4tAFPEQEWmzosJVpU/EeCKICgPjMCHknzt5jQ19Fx7OTrtUVFxvUcPGMvXTFbiWyOpa5GZ2/cEKYWLE5zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4942
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/21 9:55 AM, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 21, 2021 at 08:55:07AM -0600, Tom Lendacky wrote:
>> The hardware will allow any SEV capable ASID to be run as SEV-ES, however,
>> the SEV firmware will not allow the activation of an SEV-ES VM to be
>> assigned to an ASID greater than or equal to the SEV minimum ASID value. The
>> reason for the latter is to prevent an !SEV-ES ASID starting out as an
>> SEV-ES guest and then disabling the SEV-ES VMCB bit that is used by VMRUN.
>> This would result in the downgrading of the security of the VM without the
>> VM realizing it.
>>
>> As a result, you have a range of ASIDs that can only run SEV-ES VMs and a
>> range of ASIDs that can only run SEV VMs.
> 
> I see. That makes sense. What's the downside of SEV-ES compared to SEV w/o
> ES? Are there noticeable performance / feature penalties or is the split
> mostly for backward compatibility?

SEV-ES is an incremental enhancement of SEV where the register state of 
the guest is protected/encrypted. As with a lot of performance questions, 
the answer is ...it depends. With SEV-ES, there is additional overhead 
associated with a world switch (VMRUN/VMEXIT) to restore and save 
additional register state. Also, exit events are now divided up into 
automatic exits (AE) and non-automatic exits (NAE). NAE events result in a 
new #VC exception being generated where the guest is then required to use 
the VMGEXIT instruction to communicate only the state necessary to perform 
the operation. A CPUID instruction is a good example, where a shared page 
is used to communicate required state to the hypervisor to perform the 
CPUID emulation, which then returns the results back through the shared 
page to the guest. So it all depends on how often the workload in question 
performs operations that result in a VMEXIT of the vCPU, etc.

Thanks,
Tom

> 
> Thanks.
> 
