Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3221A1A4BB0
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 23:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgDJV6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 17:58:32 -0400
Received: from mail-mw2nam12on2083.outbound.protection.outlook.com ([40.107.244.83]:6226
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbgDJV6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 17:58:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+petqu4e3v867LlkbgGaEENueZMMMTjEpZ8ds2IJ/ZWvd2GrPzM2t67rb3M3uWYRVB1YLCYhrLDI+6PHvj1KEAciZx0kux7G7+aKlGECdv7VP0ppLJIJd/tqcVDFgRxMzdxl7wFPjvEKKkbDEGNEOahTan2D02hfC8JZX96BRJ8n1o4SjWarYHqbCGtpckf/FWKjq2N2a0z6jYgS7DINB/8PdxGkJBnRvdSbY0dZwBJ5FvLR65v2HADwpskdwJrnroapVfa2cz/o0r/wdUdkz+NDUiwS+ZPuCfYEUqNyYucQMPjcUnbJ3XlzOtk6+KKawHW90Cs06afgmptH1iSzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRE+5IYlhQtMIAVL16Une/k4KS7BpmJyuDoOyQsrb8Q=;
 b=kTtktru0ScOuqhlMpa8ZtTIovmIOgTniZx/5330+M+ln1BrqHrHjAlmHWO7UbIJx6PzrCpwUZzIAu21hMsGBuvxAekGc3s+Dok8UkLTxEDvf9t2D0MjLLU2C7o90eG1dlnAB3ODKjRZMSbGxWZwOEKR1OFqVy5sWciD+PzhNQkAqQlYKAoEQaWuHBO48cCGXhqCIyFZH66EVETb2kvxVOyymviktyyl+AXFXPMKWDUTs1+7bjgXw7ZuqQoqqfCE6nSEgvTyDy6AvYyHRihk5lQXAt1zz+PX3QRciKFhjghTFpytFH4tp8nWTsz2GP6WF9BVih0WkJTI8GPYSzvhsfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRE+5IYlhQtMIAVL16Une/k4KS7BpmJyuDoOyQsrb8Q=;
 b=0/0P+/1p+rVdDUPI/fnAeP+v7KDu2jh95ih177fK8DyAzTlyKvWeMRsg7BHUMyHISLCNi54YIjTyCxp2gLuwJw5J5VfAuCpDbXFfE+n9pN5xM+uzfhrH8WZ0plhMPqKXlOpJV2PGXixgYa/R/TigOSGTkJueVFphGjNW3kTiXY0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.17; Fri, 10 Apr
 2020 21:58:28 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d%7]) with mapi id 15.20.2900.015; Fri, 10 Apr 2020
 21:58:28 +0000
Cc:     brijesh.singh@amd.com, "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        Steve Rutherford <srutherford@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
To:     Sean Christopherson <sean.j.christopherson@intel.com>
References: <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com>
 <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
 <20200408015221.GB27608@ashkalra_ubuntu_server>
 <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
 <20200410013418.GB19168@ashkalra_ubuntu_server>
 <CABayD+dDtjz7rJe1ujQ_sq88JRUzHaXXNP_hQVhD1vkXkPsXCw@mail.gmail.com>
 <CABayD+dwJeu+o+TG843XX1nWHWMz=iwW0uWBKPaG0uJEsxCYGw@mail.gmail.com>
 <CABayD+cuHv6chBT5wWHqaZWXSHaOtaOQyBrxgRj2Y=q_fOheuA@mail.gmail.com>
 <DM5PR12MB1386C01E72A71F3AB6EB1F068EDE0@DM5PR12MB1386.namprd12.prod.outlook.com>
 <4be6c1a8-de3f-1e83-23d4-e0213a1acd24@amd.com>
 <20200410214644.GL22482@linux.intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <89962d15-1048-a7f6-1443-8b66a016f8c1@amd.com>
Date:   Fri, 10 Apr 2020 16:58:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200410214644.GL22482@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: DM5PR17CA0068.namprd17.prod.outlook.com
 (2603:10b6:3:13f::30) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM5PR17CA0068.namprd17.prod.outlook.com (2603:10b6:3:13f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 21:58:25 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 24d63d7f-f411-4881-3791-08d7dd9a4cea
X-MS-TrafficTypeDiagnostic: SA0PR12MB4414:|SA0PR12MB4414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44145E1E57F85E34560C40FCE5DE0@SA0PR12MB4414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(478600001)(4744005)(66946007)(36756003)(52116002)(66476007)(45080400002)(66556008)(186003)(16526019)(31686004)(26005)(7416002)(6916009)(4326008)(54906003)(5660300002)(8936002)(86362001)(956004)(81156014)(8676002)(2906002)(53546011)(6486002)(6666004)(2616005)(6506007)(44832011)(6512007)(316002)(31696002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y55cFWAdUTDvIUuaoRoQRmhVlYYu05TcLSDHp14EccVDtElOQklyYfYRmTeVjAJAGOzzoHf4lffS/Ar9qT6GxKUIufzqp3yYTm9e0pV1BKnR4RxvIqhMaJe++O+j7gEwt6tJHvFT6A0S/rXQ8PDB8rH7G2RhYK6Ea9uTT+fxDNBCm/PiqGAawHC2n3Fek9rA83eo21zIvRMQvKkI023XV4BIdehFvjmEV3OMQLISg9cjMrHUewkuxkoHpYjzNFldHj4YYEW4DaAjy6abnInmQ3icY6Cq6K7PJ99W4ZphTm8bgFMyrCpbFmolz8a+ng0EuK3MNDf38Lx7cjZxtp6Ix3yoorVjTzibUrrEJHHMVN81zIFvJ7gvSOuydbvIEwk611oqqb70Gk3xr9cmFOF4Vnwbi01Vc7UAXOMxsIM43nH6EWqdWJSe9FIF3VNVi2La
X-MS-Exchange-AntiSpam-MessageData: XLVHMkV2/sKUg4mr5y32jGY0NDFGMPoQeIv0PU98kLEloQeyddK58CyPPsOW1nt32dYau50WsWvk3BxBjjkJJIX+UG3wxctz57gATLUt9urCWVIWwRBb57lZQ1fJyqyh24eNUqwZRmnXDfLcroXc5Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d63d7f-f411-4881-3791-08d7dd9a4cea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 21:58:28.2857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdKGMbG6zz+oFiwqdJn7CBHntIHzPS9IQVolSf6osRBEFHRdXBmRXdGiL18L4VlYVxJEcVUEDVj9G04SE9iNag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/10/20 4:46 PM, Sean Christopherson wrote:
> On Fri, Apr 10, 2020 at 04:42:29PM -0500, Brijesh Singh wrote:
>> On 4/10/20 3:55 PM, Kalra, Ashish wrote:
>>> [AMD Official Use Only - Internal Distribution Only]
> Can you please resend the original mail without the above header, so us
> non-AMD folks can follow along?  :-)

Haha :) looks like one of us probably used outlook for responding. These
days IT have been auto add some of those tags. Let me resend with it
removed.

