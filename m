Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8DEC18D830
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 20:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCTTNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 15:13:13 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:6218
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726814AbgCTTNN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 15:13:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GC1tTRhlvIYYaYF59hJ4PWVCYP4mo+hRT/pjlA284oYsvCphTX0VcSje5A/bHcAooWJFguD2V3iuMReemNZ4sDGVmqGp7tcCatd7Omhf5gzxI1nwNHkAn8GvQcx2X1G/gqGSTMrIiFwarEaaf6ztTMXvlbfyJmA59l78GzYyjnJDs/roZCRlGmcu81pkwdYajJ0a5Lo/bqjEjtXrzoxsHmjJzXaKsqzView6baN69+crJZMN2cbAxicVquh+nWXjJAlWMwY5ju0uEZB1Kxmdca899pJ0LXQmtAAiocJGi4lQyIwg++6R6KclXq3kgZUTBEh28h/O2Gwt+HN0kFo/KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Shnng4AvX5lOhmnWKLU9C1Q4b+WEC4dXj3oLRhH8riM=;
 b=DrKM9MDlcgB3M9ToQsI91NgtYqAIHPietPcue+sta9VjQf4SCEeIo7lSWTlUN++SdtNUHS/0TyA5U7NvidvEcXF73WGE0vtBU0yL6eAnrSzTLLFLeHGrmAa2KJEbnxrxzJ8g3PxUSTcWJGTuNQoc170mEigo1YnK6Q3sh21/MIisohkbAqDijaPY6W54vVxdOrtfL9H+Xnmer3ZnTQkWjbQnnK3xAczOaRpqmAomL+blLct/zaMFdIOd3Mkcw/xdk8coGcdW6TuQ383Gj6vuX7KsgNEFB49SsRtOZ2Dx7EmOfNGopVTbAz589o8s3j6BC4fWXH1eX4oyf6hv8tZ5og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Shnng4AvX5lOhmnWKLU9C1Q4b+WEC4dXj3oLRhH8riM=;
 b=PEvj5kKodr+PsLuZWxONSnsk3juv0OUw8+ceO7Jf+6UmUvzbXeUOGy7MYnCWqK953wxGB6ByjzgIvXB7eB/F9PaVQXMialkN/2pRgxLzzpz8pu/KRQkTE05TId35BSH0XMUakJHkk34dL1IwFyfq+pNwyF6S0OjVFZsjLKs8g/E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from CY4PR12MB1926.namprd12.prod.outlook.com (2603:10b6:903:11b::11)
 by CY4PR12MB1525.namprd12.prod.outlook.com (2603:10b6:910:11::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Fri, 20 Mar
 2020 19:13:09 +0000
Received: from CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4]) by CY4PR12MB1926.namprd12.prod.outlook.com
 ([fe80::e5ec:63d5:a9a8:74c4%12]) with mapi id 15.20.2835.017; Fri, 20 Mar
 2020 19:13:09 +0000
Cc:     brijesh.singh@amd.com
Subject: Re: [PATCH] KVM: SVM: document KVM_MEM_ENCRYPT_OP, let userspace
 detect if SEV is available
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200320174245.5220-1-pbonzini@redhat.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <e7a293bf-acbf-b69a-a082-4a2cce9701b0@amd.com>
Date:   Fri, 20 Mar 2020 14:14:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200320174245.5220-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0024.namprd05.prod.outlook.com
 (2603:10b6:803:40::37) To CY4PR12MB1926.namprd12.prod.outlook.com
 (2603:10b6:903:11b::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN4PR0501CA0024.namprd05.prod.outlook.com (2603:10b6:803:40::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Fri, 20 Mar 2020 19:13:08 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7668df3a-f9ee-40d1-9e80-08d7cd02ba11
X-MS-TrafficTypeDiagnostic: CY4PR12MB1525:|CY4PR12MB1525:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1525412092667CEDB3CDF5BCE5F50@CY4PR12MB1525.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(199004)(2906002)(36756003)(52116002)(44832011)(5660300002)(478600001)(186003)(8936002)(16526019)(6666004)(4326008)(2616005)(81156014)(31686004)(26005)(956004)(316002)(4744005)(81166006)(31696002)(86362001)(6506007)(8676002)(66946007)(53546011)(6512007)(66556008)(6486002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1525;H:CY4PR12MB1926.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 88ON0HfLkkNTVm61RWpiKni4qhDLtmPTuW5V6m1ikDYiKDmf+SE9j0j/xf08YTkSW41n905cvr1unnXRWl89HejSdF+rv4KS2FQNFO9o7KCX0LMLIZeADhOMmrxfLbfidv14QLdaV/H0owPu0ZCXnLBwalC5CeC08kYIM3Mv33HcS0TeMSSfCAwRhPnvQhUIgnXAkP9pIspjiKzb1L/0EEVhf7B2l5Xl/OhAg64T1djxZvCM+CiD8NEi57S4kYLnlojaeOdCHiOnCeT3Dm4ynLVWQSqrrTJj7lkFsFd4F75hnw1+jd3gT1agczFWQzzTB1i1WxBj5+b4iyuNvp7xWUekFg0cLskdi1JFdApST1rhDdXA+xIa5umsttMH1PVM4W2az1UQGOl8f9OczK8qWzu9gMY0J7SQXmOQ7ycKq3LHn9quGmBwlzart+owjY1X
X-MS-Exchange-AntiSpam-MessageData: fGgF5qZof3t5ZFMqP6+yjgNNNbJ0DA2+iqw3pVUEIGW1S0Z8VB0Ky/BWMHPOv44Zj+aandLtwDLhlisW6hybT5ytUyQNqqi0TsQcWzqZ4CHgWEBOaYh61qtym+FZaAxntzywfSD6eIh28VUYpXTLkg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7668df3a-f9ee-40d1-9e80-08d7cd02ba11
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 19:13:09.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eb3R7EMRrXnX9rPTNASL+ou24m5eH2TSTmtdxsxaz2xXi1YWV1Apwn1UpTzzsZEXDVJb/KUH9Vc2OriLO2zP4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1525
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/20/20 12:42 PM, Paolo Bonzini wrote:
> Userspace has no way to query if SEV has been disabled with the
> sev module parameter of kvm-amd.ko.  Actually it has one, but it
> is a hack: do ioctl(KVM_MEM_ENCRYPT_OP, NULL) and check if it
> returns EFAULT.  Make it a little nicer by returning zero for
> SEV enabled and NULL argument, and while at it document the
> ioctl arguments.
>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

thanks

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


