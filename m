Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74D1512C63
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241969AbiD1HMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbiD1HMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:12:30 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA7398F7D
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:09:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSreF7zWRhr1rpdZqgGZduaWGQjjn9bKHYnvmW0tpXZTUq7FIiJB931O5Jis0HA2jrscNPxZCciyNZISS6R8UIAzIZCiVCptePZYZEqYTd0HQXsMYEKgweURecziVSJdnBRQlQRWbz0/n1HhhNvi6YphixJoHSBF2Z1MKEz8OBCaKBx/MzWcMlbHVzy1POdQNefLMtjXcL12GNaLcNLtNbY+LwoURrWWP0P4+N6W4BUCUOaCnnMIk78TSwj5VjFXKaU1sbJJQZfcdNDUBRsWtZmiHMOwTQ2aTL5AyvhrgnOd12p7NcgobK/1P6owjJ6IoVACL3OjtNZ1bzhlQNP/OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3l/a4u9fgi1omew0Sx/YDOJvUJHCy46z423OgT3/2qE=;
 b=ZaSWV7ONqQOo6hrBKtW+wtm88M4JcbChWLtU/IGAVDBwp2i8OL4yzZ4/1uPMAaWG/0n2ntKhJCKjm0oDQuS+rthPhodEUxY8dUpRQ9fHDFGJHMPEJ2Arldl/4U2q/pM1L+nwBcbWI/s9JiOvIqgriUtM15UNJDy0xvb5J9y8AYGv25eRD7bbLL1z1LIeCZyv+X2PX0Xqdc11JyKhgwREkhSVdYwjiPjxtGySkRdATUztbp9f8ee7GZ8B0q78u8F8O2FPnfC/zXO2qRt7ZoyPfOWawd9tLbp30MH3pjq/oQqRSDwJ9Gi8Iax+9/GEDYyiIxqFzpicVtQ7olLUWGgTiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3l/a4u9fgi1omew0Sx/YDOJvUJHCy46z423OgT3/2qE=;
 b=4Xk36XPc4j2KGSsP700p0MUdOGI9J0Xcu0mC/p7LV9OzCh+IkwVrZzfvJtsfwxF/I44W93epSyxlkOKmaATg4ru3xrB3SKrdaUegZkzuRZ7fRrDRa71caDBFO5YYNYOyyWA5WiwJPTIYE4E5C45zmerw1MIzQ/eigtOBL13kRgw=
Received: from DM6PR02CA0089.namprd02.prod.outlook.com (2603:10b6:5:1f4::30)
 by BL1PR12MB5756.namprd12.prod.outlook.com (2603:10b6:208:393::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 07:09:10 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::1e) by DM6PR02CA0089.outlook.office365.com
 (2603:10b6:5:1f4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14 via Frontend
 Transport; Thu, 28 Apr 2022 07:09:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 07:09:10 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 02:09:08 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v4 0/8] Move npt test cases and NPT code improvements
Date:   Thu, 28 Apr 2022 07:08:43 +0000
Message-ID: <20220428070851.21985-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c38ff49-532c-4a26-f410-08da28e5fe59
X-MS-TrafficTypeDiagnostic: BL1PR12MB5756:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5756BD5E8E743DF1E23A5A70FDFD9@BL1PR12MB5756.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YDSVc778c6tDl+lwHXl5lCsLh5WeHN9K0DwvV5AxZoxJQ1ccNBqG511QztPNiGr7mXVJgB2JUKr0fE9A1/qQZMEHzNPWtR1S+uUagCaaktiOTuWp/LsVMPdQzAFd86MlOLJw/1iS7MogshswXzbXDhkOvQsfOJkF3VpI0HAm+4Kur1i0N53kyqVYvB+wpHSLGL3lhBVf7CQgxrtjWpQDO4dJCM5amT/9a/AJnJmIkdaKfoYZJqTR5bgtUaRpMa7exuLyB6YSnuyLdAWRZiz2VPB9ldjSDOesZWFj3m/uzSK1TqYkU08OmZ4DOALGDZfK6oGimNrpQpOgNWxhjWB9HqlXxlWVi/Eqf3GclIfuFlF2VJZdJzxnzg2nhBP79vNxTnCIWxctuyV8gouEdDsYE3ZS3FVNfouJIJj63frSHP++QYEGuDL/Eb0jhIhIzCjVkY+YObxx2PjeJq4j3o+05r4cw7U7CgoAdNG8If70F8xVTXR3yZatIvY2nTx9nE8plWheKi2tnE7nyVPyBaOfhDmQCoEp/vSPtp8YkUsfoW7bi3/ANqo2ei9tYXMf8ndnD5uuRp5FV5ep+qci6PILgLqSY1x1EEU66e3VxFi7W2TTac+6cGiblhfOtLTsKg9FUkPcO+CRNbW8q5bFPZ0VVDcFEeK+DYK+APW/6RpAFLyRMfhSZyYMdtqEwSvvRzQWPNGmFW2gTyKqG4Hd5tC4wQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(26005)(8936002)(36860700001)(70206006)(70586007)(7696005)(110136005)(36756003)(40460700003)(6666004)(508600001)(83380400001)(86362001)(82310400005)(5660300002)(316002)(2616005)(426003)(186003)(336012)(1076003)(47076005)(16526019)(8676002)(2906002)(44832011)(356005)(4326008)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:09:10.5026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c38ff49-532c-4a26-f410-08da28e5fe59
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5756
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If __setup_vm() is changed to setup_vm(), KUT will build tests with 
PT_USER_MASK set on all PTEs. It is a better idea to move nNPT tests to their
own file so that tests don't need to fiddle with page tables midway.

The quick approach to do this would be to turn the current main into a small
helper, without calling __setup_vm() from helper.

setup_mmu_range() function in vm.c was modified to allocate new user pages to 
implement nested page table.

Current implementation of nested page table does the page table build up 
statistically with 2048 PTEs and one pml4 entry. With newly implemented
routine, nested page table can be implemented dynamically based on the RAM size
of VM which enables us to have separate memory ranges to test various npt test
cases.

Based on this implementation, minimal changes were required to be done in below
mentioned existing APIs:
npt_get_pde(), npt_get_pte(), npt_get_pdpe().

v1 -> v2
Added new patch for building up a nested page table dynamically and did minimal
changes required to make it adaptable with old test cases.

v2 -> v3
Added new patch to change setup_mmu_range to use it in implementation of nested
page table.
Added new patches to correct indentation errors in svm.c, svm_npt.c and 
svm_tests.c.
Used scripts/Lindent from linux source code to fix indentation errors.

v3 -> v4
Lindent script was not working as expected. So corrected indentation errors in
svm.c and svm_tests.c without using Lindent

Manali Shukla (8):
  x86: nSVM: Move common functionality of the main() to helper
    run_svm_tests
  x86: nSVM: Move all nNPT test cases from svm_tests.c to a separate
    file.
  x86: nSVM: Allow nSVM tests run with PT_USER_MASK enabled
  x86: Improve set_mmu_range() to implement npt
  x86: nSVM: Build up the nested page table dynamically
  x86: nSVM: Correct indentation for svm.c
  x86: nSVM: Correct indentation for svm_tests.c part-1
  x86: nSVM: Correct indentation for svm_tests.c part-2

 lib/x86/vm.c        |   37 +-
 lib/x86/vm.h        |    3 +
 x86/Makefile.common |    2 +
 x86/Makefile.x86_64 |    2 +
 x86/svm.c           |  227 ++-
 x86/svm.h           |    5 +-
 x86/svm_npt.c       |  391 +++++
 x86/svm_tests.c     | 3365 +++++++++++++++++++------------------------
 x86/unittests.cfg   |    6 +
 9 files changed, 2035 insertions(+), 2003 deletions(-)
 create mode 100644 x86/svm_npt.c

-- 
2.30.2

