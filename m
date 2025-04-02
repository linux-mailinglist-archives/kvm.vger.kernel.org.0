Return-Path: <kvm+bounces-42453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7DBFA7881D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 08:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B10AC189074D
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 06:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E0923314A;
	Wed,  2 Apr 2025 06:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n02NuZ7H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9C232792
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 06:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743575408; cv=none; b=qTKGO+h4kVOruQIct57vYozC9G1XV3+ufkjZaeg/a2hcMy841MW1Ljh3LLNDwtberTT6o5DbSRHaXJDSavx6j176IFyca89AFKxKhaOCMQUB2CzqGAJ5lx6FK77b4qP77o19uBcGqFeKBmjJPAGREy1VwAa7zjlGM90nFZ36eao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743575408; c=relaxed/simple;
	bh=BAFfE802gVTdPFPQz4Q3r6o+DtQlJB8TGNzFhyxc7Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=UX7tbVenCii0yXTFHsVC91N2ugLMFTVqSycbt4c/sk2VCVODN92c4y5a7qM65dP+SVPNPILGiPe8lMV9Csz8KCj3vniyjPQQtmX24PGYEY+cY6+p4E9VRlT111U2XjRJSCjZNeCr5apMUkQxHPvs19aGBI5S3nmMrhvttNZ7hjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n02NuZ7H; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743575405; x=1775111405;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=BAFfE802gVTdPFPQz4Q3r6o+DtQlJB8TGNzFhyxc7Gk=;
  b=n02NuZ7HVRS/n4Aw7adQhVg+3DO8Ql75S2uiNv84d2K70Qopno7pCKki
   Z2TfdpcPYRmiBw+LJvOao/ST9RomJ8fZepkKD0Up48rV2fr+2v2NFE+lH
   LyYVawo6Gn6AzjJ/hzB8oxxD1RAx10nvd/bD2vXB7SUEKx2yJKFX769bX
   OsYo6c6XhD/8AtZqcpxc/5+hVXZdhS9CqJHTp8F5LfC5Te6SVbbqggpmx
   HKuq5+LqjTNb9/GpEk1K2qbSDPt3Cw3bxNN8OdcvZAbZTww4SYaHJzYFN
   H36O5ZCzbsaVCG6/KuC2184JDmwBTtimK16B26qoTdDbXLPPNoT3f+7L3
   g==;
X-CSE-ConnectionGUID: 01HZ6pdKSVSwb1pMKUZ0Jw==
X-CSE-MsgGUID: ho5/y7jwTUmwhajzU1yqew==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="45045574"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="45045574"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 23:30:04 -0700
X-CSE-ConnectionGUID: 2GPPQw6ZTESYAwIX+9TpMQ==
X-CSE-MsgGUID: Zetf+yDTT0eJ5jCi4YtMLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="157589705"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 01 Apr 2025 23:30:03 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tzrbg-000AVm-2L;
	Wed, 02 Apr 2025 06:29:53 +0000
Date: Wed, 2 Apr 2025 14:29:38 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>
Subject: [kvm:planes-20250401 43/62]
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:269:33: error: invalid type argument of
 '->' (have 'struct stat')
Message-ID: <202504021409.aXa06kaD-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Paolo,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git planes-20250401
head:   73685d9c23b7122b44f07d59244416f8b56ed48e
commit: 6249af4632166284e82033226a1679e38cb3e6e8 [43/62] KVM: share statistics for same vCPU id on different planes
config: arm64-randconfig-003-20250402 (https://download.01.org/0day-ci/archive/20250402/202504021409.aXa06kaD-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250402/202504021409.aXa06kaD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504021409.aXa06kaD-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c: In function 'init_elf':
>> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:269:33: error: invalid type argument of '->' (have 'struct stat')
     269 |         elf.begin = mmap(0, stat->st_size, PROT_READ, MAP_PRIVATE, fd, 0);
         |                                 ^~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:279:23: error: invalid type argument of '->' (have 'struct stat')
     279 |         assert_ge(stat->st_size, sizeof(*elf.ehdr), "%lu");
         |                       ^~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:182:24: note: in definition of macro 'assert_op'
     182 |                 typeof(lhs) _lhs = (lhs);                               \
         |                        ^~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:279:9: note: in expansion of macro 'assert_ge'
     279 |         assert_ge(stat->st_size, sizeof(*elf.ehdr), "%lu");
         |         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:279:23: error: invalid type argument of '->' (have 'struct stat')
     279 |         assert_ge(stat->st_size, sizeof(*elf.ehdr), "%lu");
         |                       ^~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:182:37: note: in definition of macro 'assert_op'
     182 |                 typeof(lhs) _lhs = (lhs);                               \
         |                                     ^~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:279:9: note: in expansion of macro 'assert_ge'
     279 |         assert_ge(stat->st_size, sizeof(*elf.ehdr), "%lu");
         |         ^~~~~~~~~
>> arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:166:33: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'int' [-Wformat=]
     166 |                 fprintf(stderr, "error: %s: " fmt "\n",                 \
         |                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:186:25: note: in expansion of macro 'fatal_error'
     186 |                         fatal_error("assertion " #lhs " " #op " " #rhs  \
         |                         ^~~~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:195:41: note: in expansion of macro 'assert_op'
     195 | #define assert_ge(lhs, rhs, fmt)        assert_op(lhs, rhs, fmt, >=)
         |                                         ^~~~~~~~~
   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c:279:9: note: in expansion of macro 'assert_ge'
     279 |         assert_ge(stat->st_size, sizeof(*elf.ehdr), "%lu");
         |         ^~~~~~~~~


vim +269 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c

   163	
   164	#define fatal_error(fmt, ...)						\
   165		({								\
 > 166			fprintf(stderr, "error: %s: " fmt "\n",			\
   167				elf.path, ## __VA_ARGS__);			\
   168			exit(EXIT_FAILURE);					\
   169			__builtin_unreachable();				\
   170		})
   171	
   172	#define fatal_perror(msg)						\
   173		({								\
   174			fprintf(stderr, "error: %s: " msg ": %s\n",		\
   175				elf.path, strerror(errno));			\
   176			exit(EXIT_FAILURE);					\
   177			__builtin_unreachable();				\
   178		})
   179	
   180	#define assert_op(lhs, rhs, fmt, op)					\
   181		({								\
   182			typeof(lhs) _lhs = (lhs);				\
   183			typeof(rhs) _rhs = (rhs);				\
   184										\
   185			if (!(_lhs op _rhs)) {					\
   186				fatal_error("assertion " #lhs " " #op " " #rhs	\
   187					" failed (lhs=" fmt ", rhs=" fmt	\
   188					", line=%d)", _lhs, _rhs, __LINE__);	\
   189			}							\
   190		})
   191	
   192	#define assert_eq(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, ==)
   193	#define assert_ne(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, !=)
   194	#define assert_lt(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, <)
   195	#define assert_ge(lhs, rhs, fmt)	assert_op(lhs, rhs, fmt, >=)
   196	
   197	/*
   198	 * Return a pointer of a given type at a given offset from
   199	 * the beginning of the ELF file.
   200	 */
   201	#define elf_ptr(type, off) ((type *)(elf.begin + (off)))
   202	
   203	/* Iterate over all sections in the ELF. */
   204	#define for_each_section(var) \
   205		for (var = elf.sh_table; var < elf.sh_table + elf16toh(elf.ehdr->e_shnum); ++var)
   206	
   207	/* Iterate over all Elf64_Rela relocations in a given section. */
   208	#define for_each_rela(shdr, var)					\
   209		for (var = elf_ptr(Elf64_Rela, elf64toh(shdr->sh_offset));	\
   210		     var < elf_ptr(Elf64_Rela, elf64toh(shdr->sh_offset) + elf64toh(shdr->sh_size)); var++)
   211	
   212	/* True if a string starts with a given prefix. */
   213	static inline bool starts_with(const char *str, const char *prefix)
   214	{
   215		return memcmp(str, prefix, strlen(prefix)) == 0;
   216	}
   217	
   218	/* Returns a string containing the name of a given section. */
   219	static inline const char *section_name(Elf64_Shdr *shdr)
   220	{
   221		return elf.sh_string + elf32toh(shdr->sh_name);
   222	}
   223	
   224	/* Returns a pointer to the first byte of section data. */
   225	static inline const char *section_begin(Elf64_Shdr *shdr)
   226	{
   227		return elf_ptr(char, elf64toh(shdr->sh_offset));
   228	}
   229	
   230	/* Find a section by its offset from the beginning of the file. */
   231	static inline Elf64_Shdr *section_by_off(Elf64_Off off)
   232	{
   233		assert_ne(off, 0UL, "%lu");
   234		return elf_ptr(Elf64_Shdr, off);
   235	}
   236	
   237	/* Find a section by its index. */
   238	static inline Elf64_Shdr *section_by_idx(uint16_t idx)
   239	{
   240		assert_ne(idx, SHN_UNDEF, "%u");
   241		return &elf.sh_table[idx];
   242	}
   243	
   244	/*
   245	 * Memory-map the given ELF file, perform sanity checks, and
   246	 * populate global state.
   247	 */
   248	static void init_elf(const char *path)
   249	{
   250		int fd, ret;
   251		struct stat stat;
   252	
   253		/* Store path in the global struct for error printing. */
   254		elf.path = path;
   255	
   256		/* Open the ELF file. */
   257		fd = open(path, O_RDONLY);
   258		if (fd < 0)
   259			fatal_perror("Could not open ELF file");
   260	
   261		/* Get status of ELF file to obtain its size. */
   262		ret = fstat(fd, &stat);
   263		if (ret < 0) {
   264			close(fd);
   265			fatal_perror("Could not get status of ELF file");
   266		}
   267	
   268		/* mmap() the entire ELF file read-only at an arbitrary address. */
 > 269		elf.begin = mmap(0, stat->st_size, PROT_READ, MAP_PRIVATE, fd, 0);
   270		if (elf.begin == MAP_FAILED) {
   271			close(fd);
   272			fatal_perror("Could not mmap ELF file");
   273		}
   274	
   275		/* mmap() was successful, close the FD. */
   276		close(fd);
   277	
   278		/* Get pointer to the ELF header. */
   279		assert_ge(stat->st_size, sizeof(*elf.ehdr), "%lu");
   280		elf.ehdr = elf_ptr(Elf64_Ehdr, 0);
   281	
   282		/* Check the ELF magic. */
   283		assert_eq(elf.ehdr->e_ident[EI_MAG0], ELFMAG0, "0x%x");
   284		assert_eq(elf.ehdr->e_ident[EI_MAG1], ELFMAG1, "0x%x");
   285		assert_eq(elf.ehdr->e_ident[EI_MAG2], ELFMAG2, "0x%x");
   286		assert_eq(elf.ehdr->e_ident[EI_MAG3], ELFMAG3, "0x%x");
   287	
   288		/* Sanity check that this is an ELF64 relocatable object for AArch64. */
   289		assert_eq(elf.ehdr->e_ident[EI_CLASS], ELFCLASS64, "%u");
   290		assert_eq(elf.ehdr->e_ident[EI_DATA], ELFENDIAN, "%u");
   291		assert_eq(elf16toh(elf.ehdr->e_type), ET_REL, "%u");
   292		assert_eq(elf16toh(elf.ehdr->e_machine), EM_AARCH64, "%u");
   293	
   294		/* Populate fields of the global struct. */
   295		elf.sh_table = section_by_off(elf64toh(elf.ehdr->e_shoff));
   296		elf.sh_string = section_begin(section_by_idx(elf16toh(elf.ehdr->e_shstrndx)));
   297	}
   298	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

