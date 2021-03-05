Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DD132F5F6
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 23:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCEWhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 17:37:08 -0500
Received: from mail-eopbgr770080.outbound.protection.outlook.com ([40.107.77.80]:37706
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229922AbhCEWg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 17:36:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5wTZSPSvrsahYsP88tt4sv7AZFQDcY0ROkB/ecLczOGNyQtHGyr0jyjcF/Yeln8ERX7og2j6ZTNfFYHhdU0nrWvru6DfvR05vcU0ngnxAMRBmoDlZ+/R208Mp2ucV6j+y+3EBw5Z1e3kccvVitJxKUxaNmHgEwQAl/Nlng3Q83V90uDUSPzRy85I4qlut5SUvgVV1Y4hc0VKTHeUffIenCmgZyw6m4aOi+NCevBU2oMRkC0X733uyyKilRr3Sb7zrUXTJlTAXfdITwdKZrLlwg3b8R7jLYEuzPQJElVb8d3dOvIyG3iJAQNBIa3cpqUjEcFjbY7cnW1eSp5X7GuaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPp+pT3mTf1wFMwTW0fVBtaWe26zsbLmM1MHLzPu7rg=;
 b=NI3W6NwHAPb4md26/G8hJJBESUajjO5hCYNRz+myN9nZePrNKaxPQ5qlXpeZYn+pUypCaNSKTUy9G0xY29rJne1IYKtvZ7Bf253z2uslWDE8pyxyo86DUkIGC3r68BvhjXMlq11OaCkn+3cUC6EHZmpfkl0u2do3Tj+WtLaHkMJvho9IRktWv+qCUcdSvyHnTH/ge2XDVRRYs5yV/KEZlz6SmMdYaMJ8FORcJrml+risspK+3CdFG9NtIV4mk4JJHhKlFoUhDX0iP2xiMqYa//aWlozN6zpxvKA3KkxSHG/9ovlcqAkK60pSN2c9LLlEe2ViuxcA+CYdMBfIcXiKJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MPp+pT3mTf1wFMwTW0fVBtaWe26zsbLmM1MHLzPu7rg=;
 b=ImEhwlCFVs5HO71rV9wHZCpLhTXdy20hC7hRDKB5ws8hHd6IuRxDnLCMxOA8V2tILcyvto/4V7tGk1AH1SSMmpVLk7MMBVqjh8MA1AEtpWmQwDglfx3Njuc2/j32KcY7xpkpRCSLW02TaQcR+JqDrkPHQqYfVA5yus5pALy3GsY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2447.namprd12.prod.outlook.com (2603:10b6:802:27::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 5 Mar
 2021 22:36:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3912.018; Fri, 5 Mar 2021
 22:36:53 +0000
Date:   Fri, 5 Mar 2021 22:36:47 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Nathan Tempelman <natet@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <20210305223647.GA2289@ashkalra_ubuntu_server>
References: <20210224085915.28751-1-natet@google.com>
 <CABayD+cZ1nRwuFWKHGh5a2sVXG5AEB_AyTGqZs_xVQLoWwmaSA@mail.gmail.com>
 <9eb0b655-48ca-94d0-0588-2a4f3e5b3651@amd.com>
 <CABayD+efSV0m95+a=WT+Lvq_zZhxw2Q3Xu4zErzuyuRxMNUHfw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+efSV0m95+a=WT+Lvq_zZhxw2Q3Xu4zErzuyuRxMNUHfw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:806:f2::8) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN7PR04CA0003.namprd04.prod.outlook.com (2603:10b6:806:f2::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 22:36:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 40bdbe1b-ccc1-42b4-d650-08d8e0272c87
X-MS-TrafficTypeDiagnostic: SN1PR12MB2447:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB244790A230EAFCD00362482B8E969@SN1PR12MB2447.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7xfD94XttQ6T+XezvPpXvApb0IwQCpubAgUg7XBg+2Sy6Ly29DwY/HMvuvH9CdEkRXn+QS2iSaDr2o0L7g9pfnNAwbWfALBZTYeMZaetgLyHIoNJE6HyyJc8LIBAL55Pd0TJsHO0RnMEyNTHEodfbhIm8hJytGdhey/90adWF6qRmeGYFI/mjKhUAzi3bH/4l5sdCgQrIcs44k2tyzX436AnPq5xUwe+5DZAQ8vy1EJGlugYkYhufkQlOV93gpGPSZX7pmiHLZsdjqjcIscwGxPjPXUZxioH7+PUxglVTkBUCzXPDP0C3AFUmCH/dl5xQL7YmaJQHsO4gkhEcu6+dfvDuDlNeDgDQS9gLt7b1y+jg5aK3huXag65x1alj0Zwr2FNTVMipS7mMIG1w4M/huNvBA89ADIQfggtqIvcvBOby94xCSAuRZnvJTswWT2AzouQd8FIqRB5uoFHf/62aKJpCcP1CbVPk24aJ4+Klsioh7cfr7cx9DXrap6jy6NCvKtAEixRyPLN3ov0oF3AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(52116002)(4326008)(6666004)(2906002)(66476007)(83380400001)(66556008)(54906003)(6496006)(8676002)(478600001)(86362001)(26005)(5660300002)(956004)(6916009)(316002)(53546011)(1076003)(16526019)(33716001)(44832011)(8936002)(55016002)(9686003)(33656002)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8nFHu/ZsoYHGBYlzLVj5U3E/oRTiL5AN7neqVELeEa6CNkbbHDeKdXWrLDTk?=
 =?us-ascii?Q?JqbLw7/y3dsAPQselT3TPg8l7NddoXlQNuS8ztvCedJDtfLpRCPPezs7Yv7m?=
 =?us-ascii?Q?fSpAAF3AC1N9Zv/PjdYv7XK872+gaBI4mfmSdLHoqZlNS2E+69G89y4op2tg?=
 =?us-ascii?Q?GXtBpBszgoEf081Jy+NQGHAOsSf39pV+I351wjjFNxUtLiwF8WdGp04N5O9o?=
 =?us-ascii?Q?3Qd2LdwipqZ7dvbvVUyeXxYJ9EP/d32pAbun9P7XsKR1pFh0c2maQclRoJwW?=
 =?us-ascii?Q?Rj37TX37n7jTekvJezHlAKBsHZ/20hJzMcWLYgdYMyNcnwnP5W5quMFmQNfH?=
 =?us-ascii?Q?OBzE9VumX2HU7wQHJECE7k6yjq9C67vFhIMYr+byOXJScb2WDijDgTxa1yxD?=
 =?us-ascii?Q?OAjwDR5OoSprgXBVpKhQTBKD+wV6bMyCPJut9rnIk6yTetWzBYA15036+fUG?=
 =?us-ascii?Q?Irp12uhwSdxZHitk1i9LACZg4cgZc500f9GHq8ILZ4j3GukURf8GKa2Fyi2d?=
 =?us-ascii?Q?1XtgxvDaR+Uowf+U8RIliytDAPZ0Xes23zuFsJIIGly1vlP9mwnZMXdL8KiA?=
 =?us-ascii?Q?26JVVvopVMjiVFJseaYkrf/qS1ZhLFG33COnrDrW6F9eaK5SJit+cikB6Ewk?=
 =?us-ascii?Q?zUbIGkMzEgUIayYQhg1HSoyjdFJViX2pfZZeLucdF/GRZBcRR7NFioUQWQ24?=
 =?us-ascii?Q?+mXwvERh+fAIhMv0YGn6kcCMaduDViwShAiHuceBUWrArai+0Qb702XM0aNr?=
 =?us-ascii?Q?C8iy4bPLZcwrw1rSpUEFu5ZwuAFn7fEuduvwJhCKTNDXjFyX2ClFLv9lN0/X?=
 =?us-ascii?Q?2eI+ET/eM7bU73HGgozF5H3h6TE418VLNmRMjNPqElNVEJqtaraLjkG8eMox?=
 =?us-ascii?Q?IJyPJEN815V90/sMsAN93vasBcykiddJwfjYz7gulF0O7Vp7L0RI/n5uDwvG?=
 =?us-ascii?Q?eBXz10M+xedruuKzD7fPdFW1xpaIrrIMuFiqBu3uYj8tTkKO4aYcatt5RBJ/?=
 =?us-ascii?Q?1WTIG73wJOs0nFbZN+r7Tf3TfeQApXRxTjSUwvf9Sz//uPwYsGNsR0sfG2ij?=
 =?us-ascii?Q?7AqHhOFpT3DEZyX0ev2Sw8EJYdJ3T1ywEw7YVYUx1oRv9ZmCiwf8nzJIJfRs?=
 =?us-ascii?Q?JjHlt34Dr/j//siJsw2PvqnQH8Wuy4pYBN5xG7mNprrkjqEvYkQzQoR6SPUp?=
 =?us-ascii?Q?XY84hV8Vc6mezekIc0YtOuvLZHKfj2JNqCPqx1nU329rbVQnRjhYWGcfTDwE?=
 =?us-ascii?Q?61geKm1m3nZII9ox8UkVennPhCuHOiiH8PUF6WOEqWwp6LutscLm9Oyk5hnO?=
 =?us-ascii?Q?NsXhr4de2hKxehB+s64Ev+VX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bdbe1b-ccc1-42b4-d650-08d8e0272c87
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 22:36:53.0789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ny4nrBLOwNaSDJBxy3Dj2My0b9rpAvQJglLB0+o28Ne43E3Dbh8x61qFQMfEeP9rLEGdvwdlbMBYsaniQNzZqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2447
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 10:49:00AM -0800, Steve Rutherford wrote:
> On Thu, Feb 25, 2021 at 6:57 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> > >> +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
> > >> +{
> > >> +       struct file *mirror_kvm_file;
> > >> +       struct kvm *mirror_kvm;
> > >> +       struct kvm_sev_info *mirror_kvm_sev;
> > >> +       unsigned int asid;
> > >> +       int ret;
> > >> +
> > >> +       if (!sev_guest(kvm))
> > >> +               return -ENOTTY;
> > >
> > > You definitely don't want this: this is the function that turns the vm
> > > into an SEV guest (marks SEV as active).
> >
> > The sev_guest() function does not set sev->active, it only checks it. The
> > sev_guest_init() function is where sev->active is set.
> Sorry, bad use of the english on my part: the "this" was referring to
> svm_vm_copy_asid_to. Right now, you could only pass this sev_guest
> check if you had already called sev_guest_init, which seems incorrect.
> >
> > >
> > > (Not an issue with this patch, but a broader issue) I believe
> > > sev_guest lacks the necessary acquire/release barriers on sev->active,
> >
> > The svm_mem_enc_op() takes the kvm lock and that is the only way into the
> > sev_guest_init() function where sev->active is set.
> There are a few places that check sev->active which don't have the kvm
> lock, which is not problematic if we add in a few compiler barriers
> (ala irqchip_split et al).

Probably, sev->active accesses can be made safe using READ_ONCE() &
WRITE_ONCE().

Thanks,
Ashish
