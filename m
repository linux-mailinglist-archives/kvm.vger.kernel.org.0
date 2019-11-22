Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5504810741A
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 15:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKVOfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 09:35:01 -0500
Received: from mail-eopbgr740053.outbound.protection.outlook.com ([40.107.74.53]:14304
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbfKVOfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 09:35:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z1QRk+zsj3Y7ZtY+RZF+zuu2JZubP+M89kd+nNQhF6mPjS8Nd1uVN3pZxY2qWQd1fH8Be2yicM/GLoW1fZsGuOd0fNOtGAB3v2Ldj+MCJ3o7oFpW+OL+ZHXm3mfSOenc0nZxZ6r9rd5dpb1fM/tTuv7vaskKBlb2CR4W7xTXQujmiZW0eETj/l28FVh+DT2IJ2kZu0VhEkWHjeRa+P7fHp73b8dVm5YOelD778sw3BlYd8My34y2RIdTXtd0OoBUlb+agTMG6eyL1nRkNtDwewoFPzCifiZd7go83N5fh4ImQZU2iqEslf1rvl0ZF6AENbjQLrH2eIypgbGEQc00MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMOrQAj8GRzs43uYGVuX/dqfOg1imN3pv3l4f/cQ8x0=;
 b=MvC2u/K8D9vhwZgAvTCXPYuDsmp/d9Ktr8YsLCcab5Mb66LvZGldXZK1S6zpTma8DHbtpenNjA7JrLX0EcZ54QNv1BdX8h/Du649XtDj6QwKng13rSR6Yf5QVHFdBMTMiKYzcM8FA57j4LB4Rsp9GeQr7ywrBhkMS8FcnPn4PT7f7Oq91hkU9gTxknC8KRxcAXyyg6EbABoVh061tGkNJrO+kQmU6D8XwCpcuUAJs0e8HsplietPyfWcaCFbNNdTDgcGpM7S+aYF6mHbAdjyBfIn2FM04gf9F0Gu1RsD+pbBkdIg/nYxPEp/DNrJhtLcme+n3DKf7ot+C/PTGvBkQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMOrQAj8GRzs43uYGVuX/dqfOg1imN3pv3l4f/cQ8x0=;
 b=T8tNeULe+qg6YgBR+cIM+UWxpjHxZUOY0mY7daA3scLZ1PTeAgMuMeZkimKVnDiH+B1MA7NVq+mZ3z/mpafP2t0Z9uJu8J6E28yK0csETwTJwniy5uMvgxU+RLPno6e7tM2dq4w2tfkb683b/RT628V0zSp++4Ljo3UKHKGYnXE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from DM6PR12MB2682.namprd12.prod.outlook.com (20.176.118.13) by
 DM6PR12MB3643.namprd12.prod.outlook.com (20.178.199.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 14:34:57 +0000
Received: from DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9]) by DM6PR12MB2682.namprd12.prod.outlook.com
 ([fe80::edfa:96b9:b6fd:fbf9%7]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 14:34:57 +0000
Cc:     brijesh.singh@amd.com, Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 0/2] Limit memory encryption cpuid pass through
To:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20191121203344.156835-1-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <1a2aa147-c085-0c4f-ec7b-a7ca9cabfed4@amd.com>
Date:   Fri, 22 Nov 2019 08:34:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20191121203344.156835-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:805:f2::36) To DM6PR12MB2682.namprd12.prod.outlook.com
 (2603:10b6:5:42::13)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 51dbafad-4afe-4dae-fc38-08d76f5925ba
X-MS-TrafficTypeDiagnostic: DM6PR12MB3643:|DM6PR12MB3643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB36430E41752BAE867B5C1EE6E5490@DM6PR12MB3643.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 02296943FF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(189003)(199004)(66476007)(66556008)(54906003)(52116002)(2616005)(446003)(11346002)(86362001)(31686004)(2906002)(81166006)(2486003)(66946007)(8676002)(81156014)(4744005)(58126008)(31696002)(110136005)(316002)(8936002)(23676004)(26005)(229853002)(186003)(478600001)(7736002)(25786009)(5660300002)(305945005)(6512007)(99286004)(36756003)(65806001)(50466002)(14454004)(65956001)(4326008)(3846002)(6116002)(66066001)(47776003)(6246003)(230700001)(6486002)(76176011)(6436002)(386003)(6506007)(53546011)(44832011);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3643;H:DM6PR12MB2682.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDzHLh5r7erMeqdpQL51DOfs4eVyxGJDPgUf04MvN0JvX6oLUBr4dL0fG/FkZEvwUsIu3aXprf0kizSO00DY7CPrizJrdFe/aTY1yk0eyYVH/7gWP7GRa8kLh5+TBtP0O5+S6Psq3ee3JfeyF9ggcezPQF/ewfOlvsbl8W4JREwOr5TttPyhLOJMbGeWkCNx01A97Ckez9PbPjPSFdSXDA3dod0BRSdJG+THL7PdPmTw8hSrwjk38/Z6T8adXUZI2N4KVqNz1k30V33TtsP9asriHAGwf71Mo7TBNSkIKjQ4wcWWj3qGCn20UdRlmdmvxY32HIgsGXVJwe7/WhfETb5Ar77GeIGDpLVPfZHAqBy9wPeioyxBJ7pqdE5iNNhvt6dLSRtN4pmYUq6oCZTrHD0G5WYtEAPFzJ8/F/hqc7STNZxWV+KMnCD/Z47O3lxI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51dbafad-4afe-4dae-fc38-08d76f5925ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2019 14:34:57.5936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 00cKP+3u+ar8K3S6p8b19qTGIiGTyC0tjOXMPj6C+cuuLUS/gf3DXEmHrxmto4qWsucYAM7JxokJNH9wJc6zzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3643
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/19 2:33 PM, Peter Gonda wrote:
> KVM_GET_SUPPORTED_CPUID for 0x8000001F currently passes through all data if
> X86_FEATURE_SEV is enabled. Guests only need the SEV bit and Cbit location
> to work correctly. This series moves handing of this cpuid function out of
> svm.c to the general x86 function and masks out host data.
> 
> Peter Gonda (2):
>    KVM x86: Move kvm cpuid support out of svm
>    KVM x86: Mask memory encryption guest cpuid
> 
>   arch/x86/kvm/cpuid.c | 11 +++++++++++
>   arch/x86/kvm/svm.c   |  7 -------
>   2 files changed, 11 insertions(+), 7 deletions(-)
> 

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
