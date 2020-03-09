Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96C0817DB93
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgCIIvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:38 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgCIIvh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:37 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298pHZ3085627
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:36 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ym6487r49-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:35 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:33 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:30 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pTeB65994948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D55AAE045;
        Mon,  9 Mar 2020 08:51:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E957AAE051;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A961CE0251; Mon,  9 Mar 2020 09:51:28 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 05/36] s390/protvirt: Add sysfs firmware interface for Ultravisor information
Date:   Mon,  9 Mar 2020 09:50:55 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0016-0000-0000-000002EE8101
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0017-0000-0000-00003351DF42
Message-Id: <20200309085126.3334302-6-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 bulkscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

That information, e.g. the maximum number of guests or installed
Ultravisor facilities, is interesting for QEMU, Libvirt and
administrators.

Let's provide an easily parsable API to get that information.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kernel/uv.c | 87 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 4539003dac9d..c86d654351d1 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -325,3 +325,90 @@ int arch_make_page_accessible(struct page *page)
 EXPORT_SYMBOL_GPL(arch_make_page_accessible);
 
 #endif
+
+#if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
+static ssize_t uv_query_facilities(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%lx\n%lx\n%lx\n%lx\n",
+			uv_info.inst_calls_list[0],
+			uv_info.inst_calls_list[1],
+			uv_info.inst_calls_list[2],
+			uv_info.inst_calls_list[3]);
+}
+
+static struct kobj_attribute uv_query_facilities_attr =
+	__ATTR(facilities, 0444, uv_query_facilities, NULL);
+
+static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%d\n",
+			uv_info.max_guest_cpus);
+}
+
+static struct kobj_attribute uv_query_max_guest_cpus_attr =
+	__ATTR(max_cpus, 0444, uv_query_max_guest_cpus, NULL);
+
+static ssize_t uv_query_max_guest_vms(struct kobject *kobj,
+				      struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%d\n",
+			uv_info.max_num_sec_conf);
+}
+
+static struct kobj_attribute uv_query_max_guest_vms_attr =
+	__ATTR(max_guests, 0444, uv_query_max_guest_vms, NULL);
+
+static ssize_t uv_query_max_guest_addr(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%lx\n",
+			uv_info.max_sec_stor_addr);
+}
+
+static struct kobj_attribute uv_query_max_guest_addr_attr =
+	__ATTR(max_address, 0444, uv_query_max_guest_addr, NULL);
+
+static struct attribute *uv_query_attrs[] = {
+	&uv_query_facilities_attr.attr,
+	&uv_query_max_guest_cpus_attr.attr,
+	&uv_query_max_guest_vms_attr.attr,
+	&uv_query_max_guest_addr_attr.attr,
+	NULL,
+};
+
+static struct attribute_group uv_query_attr_group = {
+	.attrs = uv_query_attrs,
+};
+
+static struct kset *uv_query_kset;
+static struct kobject *uv_kobj;
+
+static int __init uv_info_init(void)
+{
+	int rc = -ENOMEM;
+
+	if (!test_facility(158))
+		return 0;
+
+	uv_kobj = kobject_create_and_add("uv", firmware_kobj);
+	if (!uv_kobj)
+		return -ENOMEM;
+
+	uv_query_kset = kset_create_and_add("query", NULL, uv_kobj);
+	if (!uv_query_kset)
+		goto out_kobj;
+
+	rc = sysfs_create_group(&uv_query_kset->kobj, &uv_query_attr_group);
+	if (!rc)
+		return 0;
+
+	kset_unregister(uv_query_kset);
+out_kobj:
+	kobject_del(uv_kobj);
+	kobject_put(uv_kobj);
+	return rc;
+}
+device_initcall(uv_info_init);
+#endif
-- 
2.24.1

