Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E36058824F
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiHBTLe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 15:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHBTLc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 15:11:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904A252450;
        Tue,  2 Aug 2022 12:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AE3A61458;
        Tue,  2 Aug 2022 19:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADC1C433D6;
        Tue,  2 Aug 2022 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659467490;
        bh=AdagszibE5bt3ilsNkn8aJFKv00GWBMAz4V1vX8QZUk=;
        h=From:To:Cc:Subject:Date:From;
        b=EGvP9sDLBDkfd8Qs68lGvlJMSMWICuZUvJQxrvbXZri0BWiVW6T5Nb5FyoPJndzSm
         8OFsnrXFeWBAlh7yUboluixTabw7jbQ1r8swN3E9h7P6YZgk0NyTTPtPIRt40HMEKA
         k6yWrs0GO82KhXl2Mf8no2xGgUw8c2AuYVbDkWnVDJ4YKpP0CxHr5NS+wqihi5fAp8
         36KW0rKzuzSt9CuaeQOzehyP1uajPjupcJ7oS82CPheuSixvPIbq5kliwyhh6Isu/j
         TVen354FA8JyunNF0F6BQPkNbi5uHz5yMbcaU8N17kJVe9AcMuYmj0F577QYy7f3qm
         En8dSVcYuvMnA==
From:   broonie@kernel.org
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the kvms390-fixes tree
Date:   Tue,  2 Aug 2022 20:11:24 +0100
Message-Id: <20220802191124.1985308-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  tools/testing/selftests/kvm/s390x/tprot.c

between commit:

  fd35ba6add67a ("KVM: s390: selftests: Use TAP interface in the tprot test")

from the kvms390-fixes tree and commit:

  0c073227df505 ("KVM: s390: selftests: Use TAP interface in the tprot test")

and subsequent commits from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc tools/testing/selftests/kvm/s390x/memop.c
index e704c6fa5758e,9113696d5178a..0000000000000
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
diff --cc tools/testing/selftests/kvm/s390x/resets.c
index 889449a22e7ad,19486084eb309..0000000000000
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
diff --cc tools/testing/selftests/kvm/s390x/tprot.c
index 14d74a9e7b3d4,a9a0b76e5fa45..0000000000000
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@@ -183,30 -181,29 +181,35 @@@ static void guest_code(void
  	GUEST_SYNC(perform_next_stage(&i, mapped_0));
  }
  
- #define HOST_SYNC_NO_TAP(vmp, stage)						\
- ({										\
- 	struct kvm_vm *__vm = (vmp);						\
- 	struct ucall uc;							\
- 	int __stage = (stage);							\
- 										\
- 	vcpu_run(__vm, VCPU_ID);						\
- 	get_ucall(__vm, VCPU_ID, &uc);						\
- 	if (uc.cmd == UCALL_ABORT) {						\
- 		TEST_FAIL("line %lu: %s, hints: %lu, %lu", uc.args[1],		\
- 			  (const char *)uc.args[0], uc.args[2], uc.args[3]);	\
- 	}									\
- 	ASSERT_EQ(uc.cmd, UCALL_SYNC);						\
- 	ASSERT_EQ(uc.args[1], __stage);						\
+ #define HOST_SYNC_NO_TAP(vcpup, stage)				\
+ ({								\
+ 	struct kvm_vcpu *__vcpu = (vcpup);			\
+ 	struct ucall uc;					\
+ 	int __stage = (stage);					\
+ 								\
+ 	vcpu_run(__vcpu);					\
+ 	get_ucall(__vcpu, &uc);					\
+ 	if (uc.cmd == UCALL_ABORT)				\
+ 		REPORT_GUEST_ASSERT_2(uc, "hints: %lu, %lu");	\
+ 	ASSERT_EQ(uc.cmd, UCALL_SYNC);				\
+ 	ASSERT_EQ(uc.args[1], __stage);				\
+ })
+ 
+ #define HOST_SYNC(vcpu, stage)			\
+ ({						\
+ 	HOST_SYNC_NO_TAP(vcpu, stage);		\
+ 	ksft_test_result_pass("" #stage "\n");	\
  })
  
 +#define HOST_SYNC(vmp, stage)			\
 +({						\
 +	HOST_SYNC_NO_TAP(vmp, stage);		\
 +	ksft_test_result_pass("" #stage "\n");	\
 +})
 +
  int main(int argc, char *argv[])
  {
+ 	struct kvm_vcpu *vcpu;
  	struct kvm_vm *vm;
  	struct kvm_run *run;
  	vm_vaddr_t guest_0_page;
