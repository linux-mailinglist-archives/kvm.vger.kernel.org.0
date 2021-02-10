Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80C316B2C
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 17:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhBJQ1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 11:27:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhBJQ1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 11:27:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AGEZZd066895;
        Wed, 10 Feb 2021 16:25:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=13SH5MlOVluhHPvrEAKBUd6WK+nQdgLBJkouaZW2Shk=;
 b=RM76rVfdlUdmOFTSxmMmgztgOMNzvUhiCfPqstP3JLyL3LUbOGC49wsesHfCbWJ/Q3O/
 MkrwNwU9o9jPC+zFU/B2vIyPR0by0DazTYO6H1cRUxuIGUKpul/mBU3aXmrhZy/1qQ60
 /U1G2TT8gV8hKcY7g1o7noRKGSYD6UPXEa15cbhwhv3gug1TuLtDeG0PSH2fQQtugVJG
 abTb5bkQJ+nV1qbb46FrC5UDFQmoqnMPSigAJFRTu8Mzq7+T5HUY3KEPPpvz6mnTq3ej
 5JuXMvRnMty5gmrhhH6CYmy4SqIVdx4ZjA1X/3QVSGDBOtn5kMkdgp88ZeBCtuMsPxTq fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36hjhqv3ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 16:25:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11AGFVLk009288;
        Wed, 10 Feb 2021 16:25:38 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by aserp3020.oracle.com with ESMTP id 36j512v1vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 16:25:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTe3VQF1XDVpLTkp3HnK96eg2Cyn2LIZdt3NsnFoi+4nyzAKRsJ++sNeXv6W6gYijmwny6ggdEyUFpg1yKr/phVyJeqDjlc6PoHK6K+4wiOXQwm1S9WmSQa9jVM613kD7mQZGRtiHgt/AfV/lxSeWEJuIfuwFP2fAKAcXbEegzmJV2Bnwrxz0FZs63tPRkrBKyZZJBxWQbLIEhjUoZ61Iu4alr0UQwJYgG3cqRmHgJ40bPlB/1VMPkvZ4WQAF8PMn0uryaFxIA/dLJmbzhf9BKiQa02+vnF/csYLKidYqCs6v/0ZQdpL/W2iooeNrdZ9UPCewbKwzoy/VSZPtmwkxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13SH5MlOVluhHPvrEAKBUd6WK+nQdgLBJkouaZW2Shk=;
 b=OY0jCo2Y9O060OEnmRwW6oNDl0vGvEPOqkoTxGcl4JqEHvD2YAe55p6TNX4VLAlvI7pRhzfqP9MaPN7ncjxdm3JHCc6eEENxej/YengucYglurLLioVUAeLfRWxHTa51HIlo3DvS8GWe7pkWVSxuXbQmKsiiwe0UtEpa565624D140Q04gdExoNkv4o/NNTpBlVFX4+PHwMbvzC2b4Oo3qAGPb5HZ8PqsZLueJ+4RLT7pHt/NrTUGD/9rtca71hzt9WV5CY8YWzLMhskkDZi6dpZ8eF1T/uin/63zyasMvZC19cFnjlv2MMpXl9czAFdMHFpzUCUMY9oN3xMNVZ3lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13SH5MlOVluhHPvrEAKBUd6WK+nQdgLBJkouaZW2Shk=;
 b=ZhxzMnZ92lzty6eEQm3kzAmWOlSBA6pCalptMYaBcGD6xEffBRGyitqyK5ziw6L6GNiVDPpKSfnsiPbUsgtg0h9S6UtPtPJ5PARA36oYabK36tADLgGqkFWC+8qKP6mzZY0h+zJ1M7r6E1QIvxaMHYD/du+u1lGN889yrZkwhXc=
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=oracle.com;
Received: from DM5PR10MB2044.namprd10.prod.outlook.com (2603:10b6:3:110::17)
 by DM5PR1001MB2297.namprd10.prod.outlook.com (2603:10b6:4:31::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 10 Feb
 2021 16:25:36 +0000
Received: from DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe]) by DM5PR10MB2044.namprd10.prod.outlook.com
 ([fe80::3c1b:996a:6c0f:5bbe%6]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 16:25:36 +0000
Date:   Wed, 10 Feb 2021 10:25:30 -0600
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com,
        pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v8 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210210162530.GA84305@dt>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
 <20210202041315.196530-8-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202041315.196530-8-david@gibson.dropbear.id.au>
X-Originating-IP: [137.254.7.171]
X-ClientProxiedBy: SJ0PR13CA0203.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::28) To DM5PR10MB2044.namprd10.prod.outlook.com
 (2603:10b6:3:110::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dt (137.254.7.171) by SJ0PR13CA0203.namprd13.prod.outlook.com (2603:10b6:a03:2c3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Wed, 10 Feb 2021 16:25:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a46a51cb-02ae-493a-42c8-08d8cde07f26
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2297:
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2297BBCE61785C882047E991E68D9@DM5PR1001MB2297.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdbyVt8mllxoMTMwA4hURd6ztFjr9DYdYhuTbNYX2pniMrDcZiXmNxj3BS6epKIy5xeIsEQ7xGLFLYjZwaI/f5/yC2bCdfoyZqcagVhWIPuMzjNcRWCghAfD0tyL/ZBZU+eqvTluSbIRQjUCA6OVHClrKjElH2IiQIqTsoIuP1N7nv9d4cHifcaP5/gSEVqzy4BsVXayb8Bws5eYY2JGk5lInwA5zVHiLr48El9LnQvr3g/ttbsPPHQjRz5wwgLzbYYj5vM1f2UmcjjCNyD344sTzN6iaOfNszP7pGDn5BImAtk5yprOe9TwiYd1jGcs0IvxUTyuWa95ao4LMWycd+Fpu300lNLh8UJUTP2RCJC81Krm8nj4QP9lF7plslQuSXrEgpw3MsOIfEoThryEN19ZNwPCcKdiCoLSVjwomIe6QWYdtqiEbYMRv5Hg9zFnXAsaqPpQEzQ2NxbVX2aSeTqiwAsXJNq74unHFzXTqjIIlE9+45oV03tKfhtqETWMWRLu6XaNJreS0ao1xveLpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB2044.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(366004)(396003)(4326008)(8676002)(2906002)(66556008)(54906003)(66476007)(44832011)(53546011)(33656002)(9576002)(83380400001)(956004)(1076003)(52116002)(478600001)(6496006)(5660300002)(26005)(33716001)(86362001)(8936002)(6916009)(9686003)(66946007)(316002)(55016002)(186003)(16526019)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2KtsNofj/iQY7a/034qdCAR+Xdp+JYS4/qvhwbb/AoOl6GUDrmAbK5mFbbGF?=
 =?us-ascii?Q?uRnGDsLrNuPodaImibDuZkdAj9+nv6zxevLXSlX5TYfX8ExYM/4kHIS6gulx?=
 =?us-ascii?Q?HosBMtLks6Mcn03mQ19wEnl5RaAJQ+nCxz6xboVHD6e+UEtuWtVtIz59oR3M?=
 =?us-ascii?Q?WstgOZZgntZP8PNvqoMELj0dA0MmBESU+oN0wu5bhPm+xoxmbVEkjbWUCVUl?=
 =?us-ascii?Q?KEdCWPX3C9F8cNoj/PIaheXZUfbxnmdDgwJ+qnB7uMXypAJVl5JYZXDmsQP0?=
 =?us-ascii?Q?lyCuNtr5rOUOzhUhUoY93MLERwPOrrbsM2blzwaPY5KhtKiqVJ3pFBgxaPJA?=
 =?us-ascii?Q?zuNlP8fCL8REAC7NIYUz/Hvwg3tPCRHJmOSnThUAZAikYke5C51cLGQlRSsn?=
 =?us-ascii?Q?CM61E3G1KO6fefh8DT2WzBYPoX/CS4RqicBjxrt/B/ktchtqerwHc3LsEU80?=
 =?us-ascii?Q?vEHWHDZ0YKsL51khaxTbn2DDXnBzlRAhlbNrlecaqgholCupD8SQn1bHhAiR?=
 =?us-ascii?Q?DHxV09zrSel1d2bdSSiZI3GV+IzkgZ6Yn3sVWROJppiSQ4bdoILlN0w/Fn1T?=
 =?us-ascii?Q?RUtqGlMaB7cmz455n/6Ss76HOVOHagVMcJFDyiKQvHrbzSilHn4cjJ9zrndq?=
 =?us-ascii?Q?dLEQcRD/HR4lsRwkaof9JL3UpNOwUkgLfLMhFzOeH1kWL9ZTfLQlKERXra+W?=
 =?us-ascii?Q?/z+w5E9BEbTo78o3YJ+Gp1206Tpm9JlWSrTB5d1ZmenBeKyJ5UA0/86qsULy?=
 =?us-ascii?Q?0ZY1NiUfsjA1tS0kOgg9WAvCeCYRjGyxJGpVfRechbtfVgFA9LSVgW69RNX5?=
 =?us-ascii?Q?p4wE9K5eIregK/nczH/wzvG+lYwJcddufA6BghyfZ1dLKn1NPtEIl15cjhQz?=
 =?us-ascii?Q?HetN9vlzbVILWrFDn40MYATnxzVGqO7Ts5tgLSlkngZ1XDQw7GOJa7JWD4yd?=
 =?us-ascii?Q?oOR23pwUwZ91Z+dgXtdD+u8JSXSdYm/5mucLWEQyNJVOjhcG/2sRRLr9XLhJ?=
 =?us-ascii?Q?x3wWHZFPXl/4M5NQ5nkUlQ8TVZAbFhAsTilj1P4AF5uVXgY0YukBgXXaZ7Mq?=
 =?us-ascii?Q?naJYhL+fA5JmX/vZjvCAqOv6b4yk/8eDHLgy4iJ9sp/Dzabb/hwyXOwN+nvw?=
 =?us-ascii?Q?KF+LP9uAoqbXtF0vJq0QXV2nRXlKqlhTHCUcNHHK1a7MtugyoHXEGF/n/7+S?=
 =?us-ascii?Q?OEKe+Orz9ddiW/SrhKTw1YvnzIm2KGGGijhqhn8uH5GEROWWdE2u+mTKkRK7?=
 =?us-ascii?Q?DtqSGmbataAh6zaZKEGZCtNmwUGh34z3uED0royQVCqVK8qyYPajUw58Xojl?=
 =?us-ascii?Q?0b++8qFeGMGTnDyqrbDMFDbL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a46a51cb-02ae-493a-42c8-08d8cde07f26
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB2044.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 16:25:36.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZ9/3gklRc6jVsf3e6aUIGLUQg0YkWDBBXVcZLbTV9dmj1oxx0dcLz1qGbT2Hwz1JTq0ZB7lRdijNwoEUGiH0MwFzdDaVlcWpj+LO0yiO7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2297
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100152
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-02-02 15:13:09 +1100, David Gibson wrote:
> The platform specific details of mechanisms for implementing
> confidential guest support may require setup at various points during
> initialization.  Thus, it's not really feasible to have a single cgs
> initialization hook, but instead each mechanism needs its own
> initialization calls in arch or machine specific code.
> 
> However, to make it harder to have a bug where a mechanism isn't
> properly initialized under some circumstances, we want to have a
> common place, late in boot, where we verify that cgs has been
> initialized if it was requested.
> 
> This patch introduces a ready flag to the ConfidentialGuestSupport
> base type to accomplish this, which we verify in
> qemu_machine_creation_done().
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Greg Kurz <groug@kaod.org>
> ---
>  include/exec/confidential-guest-support.h | 24 +++++++++++++++++++++++
>  softmmu/vl.c                              | 10 ++++++++++
>  target/i386/sev.c                         |  2 ++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
> index 3db6380e63..5dcf602047 100644
> --- a/include/exec/confidential-guest-support.h
> +++ b/include/exec/confidential-guest-support.h
> @@ -27,6 +27,30 @@ OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUEST_SUPPORT)
>  
>  struct ConfidentialGuestSupport {
>      Object parent;
> +
> +    /*
> +     * ready: flag set by CGS initialization code once it's ready to
> +     *        start executing instructions in a potentially-secure
> +     *        guest
> +     *
> +     * The definition here is a bit fuzzy, because this is essentially
> +     * part of a self-sanity-check, rather than a strict mechanism.
> +     *
> +     * It's not fasible to have a single point in the common machine

Just a nit pick.

s/fasible/feasible/

> +     * init path to configure confidential guest support, because
> +     * different mechanisms have different interdependencies requiring
> +     * initialization in different places, often in arch or machine
> +     * type specific code.  It's also usually not possible to check
> +     * for invalid configurations until that initialization code.
> +     * That means it would be very easy to have a bug allowing CGS
> +     * init to be bypassed entirely in certain configurations.
> +     *
> +     * Silently ignoring a requested security feature would be bad, so
> +     * to avoid that we check late in init that this 'ready' flag is
> +     * set if CGS was requested.  If the CGS init hasn't happened, and
> +     * so 'ready' is not set, we'll abort.
> +     */
> +    bool ready;
>  };
>  
>  typedef struct ConfidentialGuestSupportClass {
> diff --git a/softmmu/vl.c b/softmmu/vl.c
> index 1b464e3474..1869ed54a9 100644
> --- a/softmmu/vl.c
> +++ b/softmmu/vl.c
> @@ -101,6 +101,7 @@
>  #include "qemu/plugin.h"
>  #include "qemu/queue.h"
>  #include "sysemu/arch_init.h"
> +#include "exec/confidential-guest-support.h"
>  
>  #include "ui/qemu-spice.h"
>  #include "qapi/string-input-visitor.h"
> @@ -2497,6 +2498,8 @@ static void qemu_create_cli_devices(void)
>  
>  static void qemu_machine_creation_done(void)
>  {
> +    MachineState *machine = MACHINE(qdev_get_machine());
> +
>      /* Did we create any drives that we failed to create a device for? */
>      drive_check_orphaned();
>  
> @@ -2516,6 +2519,13 @@ static void qemu_machine_creation_done(void)
>  
>      qdev_machine_creation_done();
>  
> +    if (machine->cgs) {
> +        /*
> +         * Verify that Confidential Guest Support has actually been initialized
> +         */
> +        assert(machine->cgs->ready);
> +    }
> +
>      if (foreach_device_config(DEV_GDB, gdbserver_start) < 0) {
>          exit(1);
>      }
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 590cb31fa8..f9e9b5d8ae 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -737,6 +737,8 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>      qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
>      qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
>  
> +    cgs->ready = true;
> +
>      return 0;
>  err:
>      sev_guest = NULL;
> -- 
> 2.29.2
